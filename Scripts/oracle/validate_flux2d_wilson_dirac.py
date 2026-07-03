"""
validate_flux2d_wilson_dirac.py
--------------------------------
Numerical oracle for the Gate C2 even-lattice Wilson-Dirac flux frontier.

This script reproduces the design-level checks in
`AgentTasks/nerd-gate-c2-next-frontier-2d-flux-plan-2026-07-03.md`.
It is an oracle in the sense of AGENTS.md: useful for pinning conventions and
finding a finite target, but not a trusted proof.  The Lean theorem must rest on
explicit matrices, congruence identities, and kernel-checked inertia/sign-count
lemmas.

Convention:
  H = sigma_x tensor D_x + sigma_y tensor D_y + sigma_z tensor (m + W)
  D_mu = (T_mu - T_mu^*) / (2i)
  W = r * (2 - (T_x + T_x^*)/2 - (T_y + T_y^*)/2)
  U_x(y) = exp(-2*pi*i*Q*y/L), U_y = 1

With this sign convention, the L=4, m=-1, Q=1 case has inertia -8 and overlap
index 4 via index = -inertia/2.  The plaquette holonomy is
exp(+2*pi*i*Q/L), so the full L x L torus carries L*Q flux quanta; this is a
finite zero-to-nonzero witness, not a unit-flux continuum normalization.

Tool: Python 3.x + numpy (version printed at run time)
Run:  python Scripts/oracle/validate_flux2d_wilson_dirac.py
License: project (Apache-2.0)
"""

from __future__ import annotations

import argparse
import math
import platform
from dataclasses import dataclass

import numpy as np


SIGMA_X = np.array([[0, 1], [1, 0]], dtype=complex)
SIGMA_Y = np.array([[0, -1j], [1j, 0]], dtype=complex)
SIGMA_Z = np.array([[1, 0], [0, -1]], dtype=complex)
SPIN_ID = np.eye(2, dtype=complex)


@dataclass(frozen=True)
class InertiaResult:
    positive: int
    negative: int
    zero: int
    gap: float

    @property
    def signature(self) -> int:
        return self.positive - self.negative

    @property
    def overlap_index(self) -> float:
        return -0.5 * self.signature


def site_index(L: int, x: int, y: int) -> int:
    return y * L + x


def block_index(L: int, k: int, y: int) -> int:
    return k * L + y


def shift_x(L: int, charge: int) -> np.ndarray:
    """Forward x-shift with Landau-gauge phase exp(-2*pi*i*Q*y/L)."""
    mat = np.zeros((L * L, L * L), dtype=complex)
    for y in range(L):
        phase = np.exp(-2j * math.pi * charge * y / L)
        for x in range(L):
            mat[site_index(L, (x + 1) % L, y), site_index(L, x, y)] = phase
    return mat


def shift_y(L: int) -> np.ndarray:
    """Forward y-shift with trivial link phase."""
    mat = np.zeros((L * L, L * L), dtype=complex)
    for y in range(L):
        for x in range(L):
            mat[site_index(L, x, (y + 1) % L), site_index(L, x, y)] = 1
    return mat


def wilson_dirac_hamiltonian(L: int, charge: int, mass: float, r: float = 1.0) -> np.ndarray:
    """Hermitian Wilson-Dirac matrix on an L x L torus with two spin components."""
    n_sites = L * L
    eye = np.eye(n_sites, dtype=complex)
    tx = shift_x(L, charge)
    ty = shift_y(L)
    dx = (tx - tx.conj().T) / (2j)
    dy = (ty - ty.conj().T) / (2j)
    wilson = r * (2 * eye - (tx + tx.conj().T) / 2 - (ty + ty.conj().T) / 2)
    return (
        np.kron(dx, SIGMA_X)
        + np.kron(dy, SIGMA_Y)
        + np.kron(mass * eye + wilson, SIGMA_Z)
    )


def inertia(mat: np.ndarray, tol: float) -> InertiaResult:
    herm = (mat + mat.conj().T) / 2
    vals = np.linalg.eigvalsh(herm)
    positive = int(np.sum(vals > tol))
    negative = int(np.sum(vals < -tol))
    zero = int(vals.size - positive - negative)
    gap = float(np.min(np.abs(vals)))
    return InertiaResult(positive, negative, zero, gap)


def plain_x_fourier(L: int) -> np.ndarray:
    """Unitary changing site basis from (x,y) to plain x-momentum (k,y)."""
    n_sites = L * L
    fourier = np.zeros((n_sites, n_sites), dtype=complex)
    norm = math.sqrt(L)
    for k in range(L):
        for y in range(L):
            for x in range(L):
                fourier[block_index(L, k, y), site_index(L, x, y)] = (
                    np.exp(-2j * math.pi * k * x / L) / norm
                )
    return fourier


def block_reduce_x(mat: np.ndarray, L: int) -> tuple[np.ndarray, float, list[InertiaResult]]:
    """Return plain-x block form, off-block max norm, and per-block inertias."""
    unitary = np.kron(plain_x_fourier(L), SPIN_ID)
    block_mat = unitary @ mat @ unitary.conj().T

    off_block = []
    for k1 in range(L):
        for y1 in range(L):
            for s1 in range(2):
                row = 2 * block_index(L, k1, y1) + s1
                for k2 in range(L):
                    if k1 == k2:
                        continue
                    for y2 in range(L):
                        for s2 in range(2):
                            col = 2 * block_index(L, k2, y2) + s2
                            off_block.append(abs(block_mat[row, col]))

    per_block = []
    for k in range(L):
        indices = [
            2 * block_index(L, k, y) + spin
            for y in range(L)
            for spin in range(2)
        ]
        per_block.append(inertia(block_mat[np.ix_(indices, indices)], 1e-8))

    return block_mat, max(off_block, default=0.0), per_block


def validate(args: argparse.Namespace) -> int:
    print("2D Wilson-Dirac flux oracle")
    print(f"python={platform.python_version()} numpy={np.__version__}")
    print(f"mass={args.mass} r={args.r} tol={args.tol}")
    print("phase convention: U_x(y)=exp(-2*pi*i*Q*y/L); total flux quanta = L*Q")
    print()

    expected = {
        (3, 0): 0.0,
        (3, 1): 0.0,
        (3, 2): 0.0,
        (4, 0): 0.0,
        (4, 1): 4.0,
        (4, 2): 0.0,
        (5, 0): 0.0,
        (5, 1): 5.0,
        (5, 2): 0.0,
    }
    ok = True

    for L in args.L:
        for charge in args.charge:
            mat = wilson_dirac_hamiltonian(L, charge, args.mass, args.r)
            herm_error = float(np.max(np.abs(mat - mat.conj().T)))
            res = inertia(mat, args.tol)
            det = np.linalg.det(mat)
            print(
                f"L={L:2d} Q={charge:2d} total_flux={L * charge:3d} "
                f"n+= {res.positive:2d} n-= {res.negative:2d} "
                f"sig={res.signature:3d} index={res.overlap_index:5.1f} "
                f"gap={res.gap:.6g} det={det.real:.6g}+{det.imag:.2g}i "
                f"herm_err={herm_error:.2g}"
            )
            if args.assert_default and (L, charge) in expected:
                if abs(res.overlap_index - expected[(L, charge)]) > args.tol:
                    ok = False
                    print(
                        f"  ERROR: expected index {expected[(L, charge)]}, "
                        f"got {res.overlap_index}"
                    )
                if herm_error > args.tol:
                    ok = False
                    print(f"  ERROR: Hermitian error {herm_error} exceeds tolerance")

    if 4 in args.L and 1 in args.charge:
        print()
        print("plain-x Fourier block check for L=4, Q=1")
        mat = wilson_dirac_hamiltonian(4, 1, args.mass, args.r)
        _, off_block_max, blocks = block_reduce_x(mat, 4)
        print(f"off_block_max={off_block_max:.3g}")
        if args.assert_default and off_block_max > 1e-10:
            ok = False
            print("  ERROR: off-block entries are not numerically zero")
        for k, res in enumerate(blocks):
            print(
                f"  k={k}: n+={res.positive} n-={res.negative} "
                f"sig={res.signature} index={res.overlap_index:.1f} gap={res.gap:.6g}"
            )
            if args.assert_default and res.signature != -2:
                ok = False
                print(f"  ERROR: expected block signature -2, got {res.signature}")

    if ok:
        print("\nOK: oracle checks passed")
        return 0
    print("\nFAILED: oracle checks did not match expected values")
    return 1


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--L", type=int, nargs="+", default=[3, 4, 5])
    parser.add_argument("--charge", type=int, nargs="+", default=[0, 1, 2])
    parser.add_argument("--mass", type=float, default=-1.0)
    parser.add_argument("--r", type=float, default=1.0)
    parser.add_argument("--tol", type=float, default=1e-8)
    parser.add_argument(
        "--no-assert-default",
        dest="assert_default",
        action="store_false",
        help="print values without checking the default L=3,4,5 table",
    )
    parser.set_defaults(assert_default=True)
    return parser


if __name__ == "__main__":
    raise SystemExit(validate(build_parser().parse_args()))
