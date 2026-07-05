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

import numpy as np


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
class Z2TransferSummary:
    L: int
    T: int
    beta: float
    partition_transfer: float
    partition_full: float
    flux_transfer: float
    flux_full: float
    flux_correlation_tau: int
    flux_correlation_transfer: float
    flux_correlation_full: float
    eigenvalues: tuple[float, ...]
    sector_eigenvalues_plus: tuple[float, ...]
    sector_eigenvalues_minus: tuple[float, ...]


def model_descriptor(L: int, T: int, beta: float) -> dict:
    """Return a JSON-ready descriptor for this finite transfer model."""

    return {
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
        "sector_symmetries": [
            {
                "name": "global_center_flip",
                "action": "u -> -u on every spatial link",
                "projectors": ["(I + F) / 2", "(I - F) / 2"],
            },
        ],
        "claim_boundary": "finite oracle/evidence record, not a Lean proof",
    }


def summary_record(summary: Z2TransferSummary) -> dict:
    """Return a JSON-ready descriptor plus numerical summary/check payload."""

    partition_abs_error = abs(summary.partition_transfer - summary.partition_full)
    partition_rel_error = partition_abs_error / abs(summary.partition_full)
    flux_abs_error = abs(summary.flux_transfer - summary.flux_full)
    corr_abs_error = abs(
        summary.flux_correlation_transfer - summary.flux_correlation_full
    )
    return {
        "oracle": {
            "name": "z2_transfer_oracle",
            "version": "v0.6",
            "python": platform.python_version(),
            "numpy": np.__version__,
        },
        "descriptor": model_descriptor(summary.L, summary.T, summary.beta),
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
                "tau": summary.flux_correlation_tau,
                "transfer_trace": summary.flux_correlation_transfer,
                "full_spacetime_sum": summary.flux_correlation_full,
            },
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
        },
    }


def summarize(L: int, T: int, beta: float) -> Z2TransferSummary:
    """Compute the standard exact checks for a small Z2 slab model."""

    K = transfer_matrix(L, beta)
    flux = lambda state: spatial_flux(state, L)
    tau = 1 if T > 1 else 0
    return Z2TransferSummary(
        L=L,
        T=T,
        beta=beta,
        partition_transfer=float(np.trace(np.linalg.matrix_power(K, T))),
        partition_full=full_spacetime_partition(L, T, beta),
        flux_transfer=transfer_expectation(L, T, beta, flux),
        flux_full=full_spacetime_expectation(L, T, beta, flux),
        flux_correlation_tau=tau,
        flux_correlation_transfer=transfer_correlation(L, T, beta, flux, flux, tau),
        flux_correlation_full=full_spacetime_correlation(L, T, beta, flux, flux, tau),
        eigenvalues=tuple(float(v) for v in positive_eigenvalues(K)),
        sector_eigenvalues_plus=tuple(float(v) for v in sector_eigenvalues(L, beta, 1)),
        sector_eigenvalues_minus=tuple(float(v) for v in sector_eigenvalues(L, beta, -1)),
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--L", type=int, default=3, help="spatial circle size")
    parser.add_argument("--T", type=int, default=2, help="Euclidean time extent")
    parser.add_argument("--beta", type=float, default=0.4, help="Wilson coupling")
    parser.add_argument("--json", action="store_true", help="emit JSON summary")
    args = parser.parse_args()

    summary = summarize(args.L, args.T, args.beta)
    if args.json:
        print(json.dumps(summary_record(summary), indent=2, sort_keys=True))
        return 0

    print(f"z2_transfer_oracle | python {platform.python_version()} | numpy {np.__version__}")
    print(f"L={summary.L} T={summary.T} beta={summary.beta}")
    print(f"Tr(K^T)      = {summary.partition_transfer:.12g}")
    print(f"full sum     = {summary.partition_full:.12g}")
    print(f"flux transfer= {summary.flux_transfer:.12g}")
    print(f"flux full    = {summary.flux_full:.12g}")
    print(
        f"flux corr tau={summary.flux_correlation_tau}: "
        f"transfer={summary.flux_correlation_transfer:.12g} "
        f"full={summary.flux_correlation_full:.12g}"
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
