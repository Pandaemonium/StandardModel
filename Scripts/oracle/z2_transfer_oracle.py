#!/usr/bin/env python3
"""Finite Z2 1+1D Wilson slab transfer oracle.

This is an executable oracle, not a proof.  It implements the first finite
Euclidean transfer model described in
`AgentTasks/paper-units/dynamical-simulation-layer-brief.md`:

* states are spatial Z2 link fields on an L-site circle;
* a one-step slab kernel sums over temporal links between adjacent slices;
* full spacetime enumeration is used as the reference check.

Z2 is represented by bits: bit 0 means +1 and bit 1 means -1.
"""

from __future__ import annotations

import argparse
import itertools
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
    eigenvalues: tuple[float, ...]


def summarize(L: int, T: int, beta: float) -> Z2TransferSummary:
    """Compute the standard exact checks for a small Z2 slab model."""

    K = transfer_matrix(L, beta)
    flux = lambda state: spatial_flux(state, L)
    return Z2TransferSummary(
        L=L,
        T=T,
        beta=beta,
        partition_transfer=float(np.trace(np.linalg.matrix_power(K, T))),
        partition_full=full_spacetime_partition(L, T, beta),
        flux_transfer=transfer_expectation(L, T, beta, flux),
        flux_full=full_spacetime_expectation(L, T, beta, flux),
        eigenvalues=tuple(float(v) for v in positive_eigenvalues(K)),
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--L", type=int, default=3, help="spatial circle size")
    parser.add_argument("--T", type=int, default=2, help="Euclidean time extent")
    parser.add_argument("--beta", type=float, default=0.4, help="Wilson coupling")
    args = parser.parse_args()

    summary = summarize(args.L, args.T, args.beta)
    print(f"z2_transfer_oracle | python {platform.python_version()} | numpy {np.__version__}")
    print(f"L={summary.L} T={summary.T} beta={summary.beta}")
    print(f"Tr(K^T)      = {summary.partition_transfer:.12g}")
    print(f"full sum     = {summary.partition_full:.12g}")
    print(f"flux transfer= {summary.flux_transfer:.12g}")
    print(f"flux full    = {summary.flux_full:.12g}")
    print("eigenvalues  = " + ", ".join(f"{v:.12g}" for v in summary.eigenvalues))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
