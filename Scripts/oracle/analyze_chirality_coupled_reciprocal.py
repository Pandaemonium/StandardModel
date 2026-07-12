"""Exact slice audit for the chirality-coupled reciprocal 3+1 ansatz.

This is an external SymPy oracle, not a proof. It works over exact Gaussian
rationals and prints the determinant factorizations used to prepare the Lean
target `codex_24h_b_coupled_reciprocal_slice_nogo.lean`.

Convention: the repository matrices satisfy
  alpha_j = sigma_x tensor sigma_j,
  Xi      = sigma_x tensor I.
The coupled coin generator is sigma_z tensor sigma_x, which anticommutes with
Xi. The conditional shift acts on the second tensor factor.
"""

from itertools import permutations

import sympy as sp


def matrix_mul(a: sp.Matrix, b: sp.Matrix) -> sp.Matrix:
    return a.multiply(b, dotprodsimp=None).applyfunc(sp.expand)


def parity(p: tuple[int, ...]) -> int:
    inversions = sum(
        p[i] > p[j] for i in range(len(p)) for j in range(i + 1, len(p))
    )
    return (-1) ** inversions


def det4(a: sp.Matrix) -> sp.Expr:
    return sp.expand(
        sum(
            parity(p) * sp.prod(a[i, p[i]] for i in range(4))
            for p in permutations(range(4))
        )
    )


def main() -> None:
    z = sp.symbols("z")
    imaginary = sp.I
    one = sp.Integer(1)
    sigma_x = sp.Matrix([[0, 1], [1, 0]])
    sigma_z = sp.diag(1, -1)
    identity2 = sp.eye(2)
    kron = sp.kronecker_product

    alpha3 = kron(sigma_x, sigma_z)
    xi = kron(sigma_x, identity2)
    generator = kron(sigma_z, sigma_x)
    coin = sp.Rational(3, 5) * sp.eye(4) + imaginary * sp.Rational(4, 5) * generator
    coin_inv = (
        sp.Rational(3, 5) * sp.eye(4)
        - imaginary * sp.Rational(4, 5) * generator
    )

    def shift(w: sp.Expr) -> sp.Matrix:
        return kron(identity2, sp.diag(w, 1))

    def commutator(w: sp.Expr) -> sp.Matrix:
        return matrix_mul(
            matrix_mul(matrix_mul(shift(w), coin), shift(one / w)), coin_inv
        )

    def reciprocal(w: sp.Expr) -> sp.Matrix:
        return matrix_mul(commutator(w), commutator(one / w))

    axis3 = (
        (z + one / z) / 2 * sp.eye(4)
        - (z - one / z) / 2 * alpha3
    )
    # At q_x=pi and q_y=0, the two first live factors multiply to -I.
    slice_walk = -matrix_mul(
        matrix_mul(reciprocal(sp.Integer(-1)), reciprocal(z)), axis3
    )

    assert matrix_mul(xi, generator) + matrix_mul(generator, xi) == sp.zeros(4)
    assert matrix_mul(coin_inv, coin) == sp.eye(4)
    assert sp.factor(det4(slice_walk)) == 1

    denominator = sp.Integer(152587890625) * z**4
    positive_poly = 11376 * z**4 + 143521 * z**3 - 187294 * z**2 + 143521 * z + 11376
    negative_poly = 11376 * z**4 - 637729 * z**3 - 187294 * z**2 - 637729 * z + 11376
    det_zero = sp.factor(det4(slice_walk - sp.eye(4)))
    det_pi = sp.factor(det4(slice_walk + sp.eye(4)))
    assert sp.factor(det_zero - positive_poly**2 / denominator) == 0
    assert sp.factor(det_pi - negative_poly**2 / denominator) == 0

    x = sp.symbols("x", real=True)
    positive_reduced = 11376 * x**2 + 143521 * x - 210046
    negative_reduced = 11376 * x**2 - 637729 * x - 210046
    assert positive_reduced.subs(x, 1) == -55149
    assert positive_reduced.subs(x, 2) == 122500
    assert negative_reduced.subs(x, -1) == 439059
    assert negative_reduced.subs(x, 0) == -210046

    print("det(slice U) = 1")
    print("det(slice U - I) =", det_zero)
    print("det(slice U + I) =", det_pi)
    print("p_plus(1), p_plus(2) = -55149, 122500")
    print("p_minus(-1), p_minus(0) = 439059, -210046")
    print("PASS: both signs have an additional unit-circle crossing on this slice")


if __name__ == "__main__":
    main()
