#!/usr/bin/env python3
"""Finite Z2 1+1D Wilson slab transfer oracle.

This is an executable oracle, not a proof.  It implements the first finite
Euclidean transfer model described in
`AgentTasks/paper-units/dynamical-simulation-layer-brief.md`:

* states are spatial Z2 link fields on an L-site circle;
* a one-step slab kernel sums over temporal links between adjacent slices;
* full spacetime enumeration is used as the reference check.
* two-time Euclidean correlations and center-shift sector blocks are exposed
  as finite matrix diagnostics.

Z2 is represented by bits: bit 0 means +1 and bit 1 means -1.
"""

from __future__ import annotations

import argparse
import itertools
import json
import math
import platform
from dataclasses import dataclass
from pathlib import Path

import numpy as np

ORACLE_VERSION = "v0.13"
DESCRIPTOR_SCHEMA = "z2_1p1d_wilson_slab_transfer.v1"
SUPPORTED_OBSERVABLES = {"spatial_flux"}
SUPPORTED_CORRELATIONS = {"spatial_flux_autocorrelation"}
SUPPORTED_SECTOR_SYMMETRIES = {"global_center_flip"}
DEFAULT_TOLERANCES = {
    "partition_rel_error": 1e-10,
    "observable_abs_error": 1e-10,
    "correlation_abs_error": 1e-10,
    "matrix_symmetry_abs_error": 1e-12,
    "sector_commutator_abs_error": 1e-12,
}


def bit_sign(bit: int) -> int:
    """Return +1 for bit 0 and -1 for bit 1."""

    return 1 - 2 * (bit & 1)


def state_sign(state: int, i: int) -> int:
    """Return the Z2 sign of spatial-link `i` in a packed state."""

    return bit_sign((state >> i) & 1)


def spatial_flux(state: int, L: int) -> int:
    """Product of all spatial Z2 links in a time slice."""

    out = 1
    for i in range(L):
        out *= state_sign(state, i)
    return out


def temporal_plaquette_sign(u: int, a: int, v: int, i: int, L: int) -> int:
    """Temporal plaquette sign `a_i * v_i * a_{i+1} * u_i`.

    This is the 1+1D Z2 specialization of
    `a_i * v_i * inv(a_{i+1}) * inv(u_i)`, with inversion trivial in Z2.
    """

    return (
        state_sign(a, i)
        * state_sign(v, i)
        * state_sign(a, (i + 1) % L)
        * state_sign(u, i)
    )


def slab_action(u: int, a: int, v: int, L: int) -> int:
    """Sum of temporal plaquette signs for one slab."""

    return sum(temporal_plaquette_sign(u, a, v, i, L) for i in range(L))


def slab_weight(u: int, v: int, L: int, beta: float) -> float:
    """Gauge-summed one-step Wilson slab transfer kernel entry `K[u,v]`."""

    return math.fsum(
        math.exp(beta * slab_action(u, a, v, L)) for a in range(1 << L)
    )


def transfer_matrix(L: int, beta: float) -> np.ndarray:
    """Build the finite one-step Z2 Wilson slab transfer matrix."""

    dim = 1 << L
    return np.array(
        [[slab_weight(u, v, L, beta) for v in range(dim)] for u in range(dim)],
        dtype=np.float64,
    )


def partition_from_transfer(L: int, T: int, beta: float) -> float:
    """Return `Tr(K^T)` for the one-step transfer matrix."""

    K = transfer_matrix(L, beta)
    return float(np.trace(np.linalg.matrix_power(K, T)))


def full_spacetime_weight(spatial_states: tuple[int, ...],
                          temporal_states: tuple[int, ...],
                          L: int,
                          beta: float) -> float:
    """Wilson weight of a periodic 1+1D spacetime field.

    `spatial_states[t]` stores the spatial links on time slice `t`.
    `temporal_states[t]` stores temporal links from `t` to `t+1`.
    """

    T = len(spatial_states)
    action = 0
    for t in range(T):
        u = spatial_states[t]
        v = spatial_states[(t + 1) % T]
        a = temporal_states[t]
        action += slab_action(u, a, v, L)
    return math.exp(beta * action)


def full_spacetime_partition(L: int, T: int, beta: float) -> float:
    """Exact sum over all periodic 1+1D spacetime link fields."""

    states = range(1 << L)
    total = 0.0
    for spatial in itertools.product(states, repeat=T):
        for temporal in itertools.product(states, repeat=T):
            total += full_spacetime_weight(spatial, temporal, L, beta)
    return total


def observable_matrix(L: int, observable) -> np.ndarray:
    """Return the diagonal insertion matrix for a state observable."""

    dim = 1 << L
    out = np.zeros((dim, dim), dtype=np.float64)
    for state in range(dim):
        out[state, state] = observable(state)
    return out


def transfer_expectation(L: int, T: int, beta: float, observable) -> float:
    """Return `Tr(M_O K^T) / Tr(K^T)`."""

    K = transfer_matrix(L, beta)
    KT = np.linalg.matrix_power(K, T)
    M = observable_matrix(L, observable)
    return float(np.trace(M @ KT) / np.trace(KT))


def transfer_correlation(L: int,
                         T: int,
                         beta: float,
                         observable_a,
                         observable_b,
                         tau: int) -> float:
    """Return `Tr(M_A K^tau M_B K^(T-tau)) / Tr(K^T)`."""

    if T <= 0:
        raise ValueError("T must be positive")
    if tau < 0 or tau > T:
        raise ValueError("tau must satisfy 0 <= tau <= T")
    K = transfer_matrix(L, beta)
    numerator = np.trace(
        observable_matrix(L, observable_a)
        @ np.linalg.matrix_power(K, tau)
        @ observable_matrix(L, observable_b)
        @ np.linalg.matrix_power(K, T - tau)
    )
    denominator = np.trace(np.linalg.matrix_power(K, T))
    return float(numerator / denominator)


def transfer_correlation_spectral(L: int,
                                  T: int,
                                  beta: float,
                                  observable_a,
                                  observable_b,
                                  tau: int) -> float:
    """Evaluate the two-time trace by diagonalizing the symmetric kernel."""

    if T <= 0:
        raise ValueError("T must be positive")
    if tau < 0 or tau > T:
        raise ValueError("tau must satisfy 0 <= tau <= T")
    K = transfer_matrix(L, beta)
    herm = 0.5 * (K + K.T)
    values, vectors = np.linalg.eigh(herm)
    A = vectors.T @ observable_matrix(L, observable_a) @ vectors
    B = vectors.T @ observable_matrix(L, observable_b) @ vectors
    dim = 1 << L
    numerator = math.fsum(
        float(A[i, j] * B[j, i] * values[j] ** tau * values[i] ** (T - tau))
        for i in range(dim)
        for j in range(dim)
    )
    denominator = math.fsum(float(v ** T) for v in values)
    return numerator / denominator


def full_spacetime_expectation(L: int, T: int, beta: float, observable) -> float:
    """Exact full-spacetime expectation of a time-zero spatial observable."""

    states = range(1 << L)
    numerator = 0.0
    denominator = 0.0
    for spatial in itertools.product(states, repeat=T):
        obs = observable(spatial[0])
        for temporal in itertools.product(states, repeat=T):
            weight = full_spacetime_weight(spatial, temporal, L, beta)
            numerator += obs * weight
            denominator += weight
    return numerator / denominator


def full_spacetime_correlation(L: int,
                               T: int,
                               beta: float,
                               observable_a,
                               observable_b,
                               tau: int) -> float:
    """Exact full-spacetime two-time correlation of spatial observables."""

    if T <= 0:
        raise ValueError("T must be positive")
    if tau < 0 or tau > T:
        raise ValueError("tau must satisfy 0 <= tau <= T")
    states = range(1 << L)
    numerator = 0.0
    denominator = 0.0
    tau_mod = tau % T
    for spatial in itertools.product(states, repeat=T):
        obs = observable_a(spatial[0]) * observable_b(spatial[tau_mod])
        for temporal in itertools.product(states, repeat=T):
            weight = full_spacetime_weight(spatial, temporal, L, beta)
            numerator += obs * weight
            denominator += weight
    return numerator / denominator


def center_flip_permutation(L: int) -> np.ndarray:
    """Permutation matrix for the global Z2 center shift on spatial links."""

    dim = 1 << L
    mask = dim - 1
    out = np.zeros((dim, dim), dtype=np.float64)
    for state in range(dim):
        out[state ^ mask, state] = 1.0
    return out


def sector_projector(L: int, parity: int) -> np.ndarray:
    """Projector onto the +/- eigenspace of the global center shift."""

    if parity not in (-1, 1):
        raise ValueError("parity must be +1 or -1")
    dim = 1 << L
    identity = np.eye(dim)
    flip = center_flip_permutation(L)
    return 0.5 * (identity + parity * flip)


def sector_basis(L: int, parity: int) -> np.ndarray:
    """Orthonormal basis for the global center-shift +/- eigenspace."""

    if L <= 0:
        raise ValueError("L must be positive")
    if parity not in (-1, 1):
        raise ValueError("parity must be +1 or -1")
    dim = 1 << L
    mask = dim - 1
    seen: set[int] = set()
    columns = []
    inv_sqrt2 = 1.0 / math.sqrt(2.0)
    for state in range(dim):
        if state in seen:
            continue
        partner = state ^ mask
        seen.add(state)
        seen.add(partner)
        column = np.zeros(dim, dtype=np.float64)
        column[state] = inv_sqrt2
        column[partner] = parity * inv_sqrt2
        columns.append(column)
    return np.column_stack(columns)


def sector_block(L: int, beta: float, parity: int) -> np.ndarray:
    """Return the transfer matrix compressed to a center-shift sector."""

    basis = sector_basis(L, parity)
    K = transfer_matrix(L, beta)
    return basis.T @ K @ basis


def sector_eigenvalues(L: int,
                       beta: float,
                       parity: int,
                       tol: float = 1e-10) -> np.ndarray:
    """Return sorted positive eigenvalues in one center-shift sector."""

    return positive_eigenvalues(sector_block(L, beta, parity), tol=tol)


def positive_eigenvalues(K: np.ndarray, tol: float = 1e-10) -> np.ndarray:
    """Return sorted eigenvalues after checking numerical symmetry."""

    herm = 0.5 * (K + K.T)
    values = np.linalg.eigvalsh(herm)
    return np.array(sorted((v for v in values if v > tol), reverse=True))


@dataclass(frozen=True)
class Z2TransferDescriptor:
    """Validated descriptor parameters for the finite Z2 slab oracle."""

    L: int
    T: int
    beta: float
    space_boundary: str
    time_boundary: str
    observables: tuple[str, ...]
    correlation_taus: tuple[int, ...]
    sector_symmetries: tuple[str, ...]


@dataclass(frozen=True)
class Z2FluxCorrelation:
    """One requested spatial-flux autocorrelation check."""

    tau: int
    transfer: float
    full: float
    spectral: float


@dataclass(frozen=True)
class Z2TransferSummary:
    L: int
    T: int
    beta: float
    partition_transfer: float
    partition_full: float
    flux_transfer: float
    flux_full: float
    flux_correlation_profile: tuple[Z2FluxCorrelation, ...]
    eigenvalues: tuple[float, ...]
    sector_eigenvalues_plus: tuple[float, ...]
    sector_eigenvalues_minus: tuple[float, ...]


def _require(condition: bool, message: str) -> None:
    """Raise a descriptor validation error when `condition` is false."""

    if not condition:
        raise ValueError(message)


def _names_from_entries(entries: object, field: str) -> tuple[str, ...]:
    """Extract named entries from a descriptor list."""

    _require(isinstance(entries, list), f"descriptor field `{field}` must be a list")
    names: list[str] = []
    for idx, entry in enumerate(entries):
        _require(isinstance(entry, dict), f"`{field}[{idx}]` must be an object")
        name = entry.get("name")
        _require(isinstance(name, str), f"`{field}[{idx}].name` must be a string")
        names.append(name)
    return tuple(names)


def _correlation_taus_from_entries(entries: object, T: int) -> tuple[int, ...]:
    """Extract supported spatial-flux autocorrelation tau values."""

    if entries is None:
        return tuple(range(T))
    _require(
        isinstance(entries, list),
        "descriptor field `correlations` must be a list",
    )
    taus: list[int] = []
    for idx, entry in enumerate(entries):
        _require(isinstance(entry, dict), f"`correlations[{idx}]` must be an object")
        name = entry.get("name")
        _require(isinstance(name, str), f"`correlations[{idx}].name` must be a string")
        _require(
            name in SUPPORTED_CORRELATIONS,
            "unsupported correlation; supported correlations are "
            + ", ".join(sorted(SUPPORTED_CORRELATIONS)),
        )
        _require(
            entry.get("observable_a") == "spatial_flux"
            and entry.get("observable_b") == "spatial_flux",
            "only spatial_flux/spatial_flux correlations are supported",
        )
        raw_taus = entry.get("taus")
        _require(
            isinstance(raw_taus, list) and raw_taus,
            f"`correlations[{idx}].taus` must be a nonempty list",
        )
        for tau in raw_taus:
            _require(isinstance(tau, int), "correlation tau values must be integers")
            _require(0 <= tau <= T, "correlation tau must satisfy 0 <= tau <= T")
            taus.append(int(tau))
    _require(taus, "descriptor must request at least one correlation tau")
    return tuple(dict.fromkeys(taus))


def validate_descriptor(record: dict) -> Z2TransferDescriptor:
    """Validate and extract the supported Z2 1+1D transfer descriptor."""

    _require(isinstance(record, dict), "descriptor must be a JSON object")
    _require(
        record.get("model") == "z2_1p1d_wilson_slab_transfer",
        "descriptor model must be `z2_1p1d_wilson_slab_transfer`",
    )
    schema = record.get("schema_version")
    _require(
        schema in (None, DESCRIPTOR_SCHEMA),
        f"unsupported descriptor schema_version `{schema}`",
    )
    group = record.get("group")
    _require(isinstance(group, dict), "descriptor field `group` must be an object")
    _require(group.get("name") == "Z2", "descriptor group.name must be `Z2`")
    lattice = record.get("lattice")
    _require(isinstance(lattice, dict), "descriptor field `lattice` must be an object")
    space = lattice.get("space")
    time = lattice.get("time")
    _require(isinstance(space, dict), "descriptor lattice.space must be an object")
    _require(isinstance(time, dict), "descriptor lattice.time must be an object")
    _require(space.get("dimension") == 1, "only one spatial dimension is supported")
    shape = space.get("shape")
    _require(
        isinstance(shape, list) and len(shape) == 1 and isinstance(shape[0], int),
        "lattice.space.shape must be a one-entry integer list",
    )
    L = int(shape[0])
    T_raw = time.get("extent")
    _require(isinstance(T_raw, int), "lattice.time.extent must be an integer")
    T = int(T_raw)
    _require(L > 0, "spatial size L must be positive")
    _require(T > 0, "time extent T must be positive")
    space_boundary = space.get("boundary")
    time_boundary = time.get("boundary")
    _require(space_boundary == "periodic", "only periodic spatial boundary is supported")
    _require(time_boundary == "periodic", "only periodic time boundary is supported")
    couplings = record.get("couplings")
    _require(
        isinstance(couplings, dict),
        "descriptor field `couplings` must be an object",
    )
    beta = couplings.get("beta", couplings.get("beta_temporal"))
    _require(isinstance(beta, (int, float)), "couplings.beta must be numeric")
    observables = _names_from_entries(record.get("observables", []), "observables")
    _require(
        set(observables).issubset(SUPPORTED_OBSERVABLES),
        "unsupported observable; supported observables are "
        + ", ".join(sorted(SUPPORTED_OBSERVABLES)),
    )
    sectors = _names_from_entries(
        record.get("sector_symmetries", []),
        "sector_symmetries",
    )
    _require(
        set(sectors).issubset(SUPPORTED_SECTOR_SYMMETRIES),
        "unsupported sector symmetry; supported sector symmetries are "
        + ", ".join(sorted(SUPPORTED_SECTOR_SYMMETRIES)),
    )
    _require(
        "spatial_flux" in observables,
        "descriptor must request the `spatial_flux` observable",
    )
    correlation_taus = _correlation_taus_from_entries(
        record.get("correlations"),
        T,
    )
    _require(
        "global_center_flip" in sectors,
        "descriptor must request the `global_center_flip` sector symmetry",
    )
    return Z2TransferDescriptor(
        L=L,
        T=T,
        beta=float(beta),
        space_boundary=str(space_boundary),
        time_boundary=str(time_boundary),
        observables=observables,
        correlation_taus=correlation_taus,
        sector_symmetries=sectors,
    )


def model_descriptor(L: int, T: int, beta: float) -> dict:
    """Return a JSON-ready descriptor for this finite transfer model."""

    return {
        "schema_version": DESCRIPTOR_SCHEMA,
        "model": "z2_1p1d_wilson_slab_transfer",
        "group": {
            "name": "Z2",
            "multiplication": "sign multiplication",
            "encoding": {
                "bit_0": "+1",
                "bit_1": "-1",
            },
        },
        "lattice": {
            "space": {
                "dimension": 1,
                "shape": [L],
                "boundary": "periodic",
            },
            "time": {
                "extent": T,
                "boundary": "periodic",
            },
        },
        "state_encoding": {
            "spatial_state": "L low bits encode spatial links on one time slice",
            "temporal_state": "L low bits encode temporal links in one slab",
        },
        "couplings": {
            "beta": beta,
            "beta_spatial": 0.0,
            "beta_temporal": beta,
        },
        "plaquette_convention": "P_i(u,a,v) = a_i * v_i * a_{i+1} * u_i",
        "kernel": {
            "name": "gauge_summed_wilson_slab",
            "formula": "K(u,v) = sum_a exp(beta * sum_i P_i(u,a,v))",
        },
        "partition": "Z_T = Tr(K^T)",
        "observables": [
            {
                "name": "spatial_flux",
                "formula": "Phi(u) = prod_i u_i",
                "insertion": "diagonal",
            },
        ],
        "correlations": [
            {
                "name": "spatial_flux_autocorrelation",
                "observable_a": "spatial_flux",
                "observable_b": "spatial_flux",
                "taus": list(range(T)),
            },
        ],
        "sector_symmetries": [
            {
                "name": "global_center_flip",
                "action": "u -> -u on every spatial link",
                "projectors": ["(I + F) / 2", "(I - F) / 2"],
            },
        ],
        "claim_boundary": "finite oracle/evidence record, not a Lean proof",
    }


def matrix_record(summary: Z2TransferSummary) -> dict:
    """Return explicit finite matrices for tiny reproducibility records."""

    flux = lambda state: spatial_flux(state, summary.L)
    return {
        "spatial_state_labels": list(range(1 << summary.L)),
        "transfer_kernel": transfer_matrix(summary.L, summary.beta).tolist(),
        "spatial_flux_insertion": observable_matrix(summary.L, flux).tolist(),
        "global_center_flip": center_flip_permutation(summary.L).tolist(),
        "center_plus_projector": sector_projector(summary.L, 1).tolist(),
        "center_minus_projector": sector_projector(summary.L, -1).tolist(),
        "center_plus_block": sector_block(summary.L, summary.beta, 1).tolist(),
        "center_minus_block": sector_block(summary.L, summary.beta, -1).tolist(),
    }


def lean_surface_record() -> dict:
    """Return the Lean theorem surfaces this oracle record is meant to inform.

    The entries are provenance links for reviewers.  They do not certify that
    the executable oracle output has been imported as a Lean theorem.
    """

    return {
        "claim_boundary": "oracle evidence only; not a Lean proof",
        "modules": [
            {
                "module": "PhysicsSM.Draft.NullEdge.GateYM.TwoStateTransferSpectrum",
                "role": (
                    "small Lean spectral payload matching the 2 x 2 "
                    "transfer-shape witness"
                ),
                "surface": [
                    "PositiveDescriptor.lambda0",
                    "PositiveDescriptor.lambdaLocal",
                    "positiveDescriptor_finiteGapPrereq",
                ],
            },
            {
                "module": "PhysicsSM.Draft.NullEdge.GateYM.TwoStateTransferWitness",
                "role": "toy Module.End witness for the two-state spectral payload",
                "surface": [
                    "topCyclicityPrereq",
                    "finiteGapSpectralWitness",
                ],
            },
            {
                "module": "PhysicsSM.Draft.NullEdge.GateYM.TwoStateTransferZ2L1",
                "role": (
                    "Lean bridge proving the L=1 Z2 slab kernel equals the "
                    "two-state transfer payload"
                ),
                "surface": [
                    "slabTransfer_eq_transfer2",
                    "slabTransfer_mulVec_vacuum",
                    "slabTransfer_mulVec_local",
                    "fluxMatrix_conjTranspose",
                    "fluxMatrix_sq",
                    "fluxMatrix_mulVec_vacuum",
                    "fluxMatrix_mulVec_local",
                    "descriptor_matrix_eq_slabTransfer",
                    "descriptor_contractionFactor_eq_tanh",
                    "spectralWitness_exp_neg_gap_eq_tanh",
                    "spectralWitness",
                ],
            },
            {
                "module": "PhysicsSM.Draft.NullEdge.GateYM.FiniteGapAssembly",
                "role": "abstract finite spectral witness and gap-ratio bookkeeping",
                "surface": [
                    "FiniteGapSpectralWitness",
                    "exp_neg_localGap_eq_localSpectralRatio",
                    "localSpectralRatio_mul_exp_localGap_eq_one",
                ],
            },
            {
                "module": "PhysicsSM.Draft.NullEdge.GateYM.TransferHilbertZ2Electric",
                "role": (
                    "finite OS/GNS Z2 electric-sector bookkeeping target for "
                    "future slab bridges"
                ),
                "surface": [
                    "rpBlockElectricSector",
                    (
                        "finrank_rpHilbertSpace_eq_finrank_"
                        "rpBlockElectricSector_add_finrank_other"
                    ),
                ],
            },
        ],
    }


def summary_record(summary: Z2TransferSummary,
                   descriptor: dict | None = None,
                   include_matrices: bool = False) -> dict:
    """Return a JSON-ready descriptor plus numerical summary/check payload."""

    partition_abs_error = abs(summary.partition_transfer - summary.partition_full)
    partition_rel_error = partition_abs_error / abs(summary.partition_full)
    flux_abs_error = abs(summary.flux_transfer - summary.flux_full)
    corr_abs_error = max(
        abs(entry.transfer - entry.full)
        for entry in summary.flux_correlation_profile
    )
    corr_spectral_abs_error = max(
        abs(entry.transfer - entry.spectral)
        for entry in summary.flux_correlation_profile
    )
    primary_corr = summary.flux_correlation_profile[0]
    correlation_profile = [
        {
            "tau": entry.tau,
            "transfer_trace": entry.transfer,
            "full_spacetime_sum": entry.full,
            "spectral_sum": entry.spectral,
            "transfer_full_abs_error": abs(entry.transfer - entry.full),
            "transfer_spectral_abs_error": abs(entry.transfer - entry.spectral),
        }
        for entry in summary.flux_correlation_profile
    ]
    record = {
        "oracle": {
            "name": "z2_transfer_oracle",
            "version": ORACLE_VERSION,
            "python": platform.python_version(),
            "numpy": np.__version__,
        },
        "descriptor": descriptor or model_descriptor(summary.L, summary.T, summary.beta),
        "results": {
            "partition": {
                "transfer_trace": summary.partition_transfer,
                "full_spacetime_sum": summary.partition_full,
            },
            "spatial_flux_expectation": {
                "transfer_trace": summary.flux_transfer,
                "full_spacetime_sum": summary.flux_full,
            },
            "spatial_flux_two_time_correlation": {
                "tau": primary_corr.tau,
                "transfer_trace": primary_corr.transfer,
                "full_spacetime_sum": primary_corr.full,
                "spectral_sum": primary_corr.spectral,
            },
            "spatial_flux_two_time_correlation_profile": correlation_profile,
            "spectrum": {
                "positive_eigenvalues": list(summary.eigenvalues),
                "center_plus_positive_eigenvalues": list(
                    summary.sector_eigenvalues_plus
                ),
                "center_minus_positive_eigenvalues": list(
                    summary.sector_eigenvalues_minus
                ),
            },
        },
        "checks": {
            "partition_abs_error": partition_abs_error,
            "partition_rel_error": partition_rel_error,
            "spatial_flux_abs_error": flux_abs_error,
            "two_time_flux_abs_error": corr_abs_error,
            "two_time_flux_spectral_abs_error": corr_spectral_abs_error,
        },
        "tolerances": DEFAULT_TOLERANCES,
        "lean_surfaces": lean_surface_record(),
    }
    if include_matrices:
        record["matrices"] = matrix_record(summary)
    return record


def summarize(
    L: int,
    T: int,
    beta: float,
    correlation_taus: tuple[int, ...] | None = None,
) -> Z2TransferSummary:
    """Compute the standard exact checks for a small Z2 slab model."""

    K = transfer_matrix(L, beta)
    flux = lambda state: spatial_flux(state, L)
    taus = correlation_taus or tuple(range(T))
    correlation_profile = tuple(
        Z2FluxCorrelation(
            tau=tau,
            transfer=transfer_correlation(L, T, beta, flux, flux, tau),
            full=full_spacetime_correlation(L, T, beta, flux, flux, tau),
            spectral=transfer_correlation_spectral(L, T, beta, flux, flux, tau),
        )
        for tau in taus
    )
    return Z2TransferSummary(
        L=L,
        T=T,
        beta=beta,
        partition_transfer=float(np.trace(np.linalg.matrix_power(K, T))),
        partition_full=full_spacetime_partition(L, T, beta),
        flux_transfer=transfer_expectation(L, T, beta, flux),
        flux_full=full_spacetime_expectation(L, T, beta, flux),
        flux_correlation_profile=correlation_profile,
        eigenvalues=tuple(float(v) for v in positive_eigenvalues(K)),
        sector_eigenvalues_plus=tuple(float(v) for v in sector_eigenvalues(L, beta, 1)),
        sector_eigenvalues_minus=tuple(float(v) for v in sector_eigenvalues(L, beta, -1)),
    )


def summarize_descriptor(record: dict) -> tuple[Z2TransferDescriptor, Z2TransferSummary]:
    """Validate a descriptor and compute its exact finite transfer summary."""

    descriptor = validate_descriptor(record)
    return descriptor, summarize(
        descriptor.L,
        descriptor.T,
        descriptor.beta,
        descriptor.correlation_taus,
    )


def load_descriptor(path: Path) -> dict:
    """Load a JSON descriptor from disk."""

    with path.open("r", encoding="utf-8") as handle:
        record = json.load(handle)
    _require(isinstance(record, dict), "descriptor JSON root must be an object")
    return record


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--L", type=int, default=3, help="spatial circle size")
    parser.add_argument("--T", type=int, default=2, help="Euclidean time extent")
    parser.add_argument("--beta", type=float, default=0.4, help="Wilson coupling")
    parser.add_argument(
        "--descriptor",
        type=Path,
        help="load a JSON model descriptor instead of using --L/--T/--beta",
    )
    parser.add_argument(
        "--write-template",
        type=Path,
        help="write a JSON descriptor template for --L/--T/--beta and exit",
    )
    parser.add_argument(
        "--include-matrices",
        action="store_true",
        help="include transfer and sector matrices in JSON output",
    )
    parser.add_argument("--json", action="store_true", help="emit JSON summary")
    args = parser.parse_args()

    if args.write_template:
        descriptor = model_descriptor(args.L, args.T, args.beta)
        with args.write_template.open("w", encoding="utf-8", newline="\n") as handle:
            json.dump(descriptor, handle, indent=2, sort_keys=True)
            handle.write("\n")
        return 0

    if args.descriptor:
        descriptor = load_descriptor(args.descriptor)
        _, summary = summarize_descriptor(descriptor)
    else:
        descriptor = model_descriptor(args.L, args.T, args.beta)
        _, summary = summarize_descriptor(descriptor)

    if args.json:
        print(json.dumps(
            summary_record(
                summary,
                descriptor=descriptor,
                include_matrices=args.include_matrices,
            ),
            indent=2,
            sort_keys=True,
        ))
        return 0

    print(f"z2_transfer_oracle | python {platform.python_version()} | numpy {np.__version__}")
    print(f"schema={DESCRIPTOR_SCHEMA} oracle={ORACLE_VERSION}")
    print(f"L={summary.L} T={summary.T} beta={summary.beta}")
    print(f"Tr(K^T)      = {summary.partition_transfer:.12g}")
    print(f"full sum     = {summary.partition_full:.12g}")
    print(f"flux transfer= {summary.flux_transfer:.12g}")
    print(f"flux full    = {summary.flux_full:.12g}")
    for corr in summary.flux_correlation_profile:
        print(
            f"flux corr tau={corr.tau}: "
            f"transfer={corr.transfer:.12g} "
            f"full={corr.full:.12g} "
            f"spectral={corr.spectral:.12g}"
        )
    print("eigenvalues  = " + ", ".join(f"{v:.12g}" for v in summary.eigenvalues))
    print("sector + eig = " + ", ".join(
        f"{v:.12g}" for v in summary.sector_eigenvalues_plus
    ))
    print("sector - eig = " + ", ".join(
        f"{v:.12g}" for v in summary.sector_eigenvalues_minus
    ))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
