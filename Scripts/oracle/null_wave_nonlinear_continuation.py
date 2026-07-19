"""Exact second-order continuation audit for the two-site null wave.

This external SymPy oracle mirrors the concrete nonlinear Lorentz Palatini
link and coframe Euler coefficients on the live two-site carrier.  For a
first-order joint-stationary tangent ``v`` and a candidate second-order jet
``y``, it evaluates

    U(t) = exp(t A_v + t^2 A_y / 2) + O(t^3),
    e(t) = I + t h_v + t^2 h_y / 2,

through order two.  If ``q(v)`` is the coefficient of ``t^2`` with ``y = 0``
and ``H`` is the exact 80 by 80 joint Hessian, second-order stationarity is
equivalent to ``H y = -2 q(v)``.  The script tests that image condition for
the kernel-checked plus, cross, and mixed curvature tangents.

This is exploratory exact-rational evidence only.  Any headline result must
be restated against the concrete Lean action and checked by the Lean kernel.

Run from the repository root:

    python Scripts/oracle/null_wave_nonlinear_continuation.py
"""

from __future__ import annotations

from dataclasses import dataclass

import sympy as sp

import emit_null_wave_curvature_completeness_lean as modes
import null_wave_linearized_backreaction as linear


PARAMETER = sp.symbols("t", real=True)
HALF = sp.Rational(1, 2)
I4 = sp.eye(4)


def truncate(expression: sp.Expr) -> sp.Expr:
    """Discard terms of degree greater than two in the jet parameter."""

    expanded = sp.expand(expression)
    return sp.expand(
        sum(expanded.coeff(PARAMETER, degree) * PARAMETER**degree
            for degree in range(3))
    )


def truncate_matrix(matrix: sp.Matrix) -> sp.Matrix:
    return matrix.applyfunc(truncate)


def matrix_product(*matrices: sp.Matrix) -> sp.Matrix:
    result = I4
    for matrix in matrices:
        result = truncate_matrix(result * matrix)
    return result


@dataclass(frozen=True)
class GroupJet:
    matrix: sp.Matrix
    inverse: sp.Matrix

    def __mul__(self, other: "GroupJet") -> "GroupJet":
        return GroupJet(
            matrix_product(self.matrix, other.matrix),
            matrix_product(other.inverse, self.inverse),
        )

    def inv(self) -> "GroupJet":
        return GroupJet(self.inverse, self.matrix)


IDENTITY_JET = GroupJet(I4, I4)


def link_jet(first: sp.Matrix, second: sp.Matrix) -> GroupJet:
    """Second jet of ``exp(t G(first) + t^2 G(second) / 2)``."""

    first_generator = linear.base.generator(first)
    second_generator = linear.base.generator(second)
    square = first_generator * first_generator
    matrix = (
        I4
        + PARAMETER * first_generator
        + HALF * PARAMETER**2 * (second_generator + square)
    )
    inverse = (
        I4
        - PARAMETER * first_generator
        + HALF * PARAMETER**2 * (-second_generator + square)
    )
    return GroupJet(matrix, inverse)


def vector_fields(
    vector: sp.Matrix,
) -> tuple[dict[tuple[int, int], sp.Matrix], dict[int, sp.Matrix]]:
    links = linear.zero_link_field()
    coframes = linear.zero_coframe_field()
    for index, variable in enumerate(linear.VARIABLES):
        value = vector[index]
        if value == 0:
            continue
        if variable.kind == "A":
            links[variable.site, variable.first][variable.second] = value
        else:
            coframes[variable.site][variable.first, variable.second] = value
    return links, coframes


def connection_jets(
    first: dict[tuple[int, int], sp.Matrix],
    second: dict[tuple[int, int], sp.Matrix],
) -> dict[tuple[int, int], GroupJet]:
    return {
        (site, direction): link_jet(
            first[site, direction], second[site, direction]
        )
        for site in linear.SITES
        for direction in linear.DIRECTIONS
    }


def coframe_jets(
    first: dict[int, sp.Matrix], second: dict[int, sp.Matrix]
) -> dict[int, sp.Matrix]:
    return {
        site: I4 + PARAMETER * first[site]
        + HALF * PARAMETER**2 * second[site]
        for site in linear.SITES
    }


def two_step(
    connection: dict[tuple[int, int], GroupJet],
    site: int,
    first: int,
    second: int,
) -> GroupJet:
    return connection[site, first] * connection[
        linear.base.shift(first, site), second
    ]


def plaquette(
    connection: dict[tuple[int, int], GroupJet],
    site: int,
    first: int,
    second: int,
) -> GroupJet:
    return two_step(connection, site, first, second) * two_step(
        connection, site, second, first
    ).inv()


def coframe_wedge(
    coframe: sp.Matrix, first: int, second: int
) -> sp.Matrix:
    result = sp.zeros(6, 1)
    for component, (i, j) in enumerate(linear.base.BIVECTOR_PAIRS):
        result[component] = truncate(
            coframe[i, first] * coframe[j, second]
            - coframe[i, second] * coframe[j, first]
        )
    return result


def coframe_wedge_first(
    coframe: sp.Matrix,
    variation: sp.Matrix,
    first: int,
    second: int,
) -> sp.Matrix:
    result = sp.zeros(6, 1)
    for component, (i, j) in enumerate(linear.base.BIVECTOR_PAIRS):
        result[component] = truncate(
            variation[i, first] * coframe[j, second]
            + coframe[i, first] * variation[j, second]
            - variation[i, second] * coframe[j, first]
            - coframe[i, second] * variation[j, first]
        )
    return result


def complementary_face(
    coframe: sp.Matrix, first: int, second: int
) -> sp.Matrix:
    result = sp.zeros(6, 1)
    for c in linear.DIRECTIONS:
        for d in linear.DIRECTIONS:
            result += (
                HALF
                * linear.base.alternating(c, d, first, second)
                * linear.base.HODGE
                * coframe_wedge(coframe, c, d)
            )
    return truncate_matrix(result)


def complementary_face_first(
    coframe: sp.Matrix,
    variation: sp.Matrix,
    first: int,
    second: int,
) -> sp.Matrix:
    result = sp.zeros(6, 1)
    for c in linear.DIRECTIONS:
        for d in linear.DIRECTIONS:
            result += (
                HALF
                * linear.base.alternating(c, d, first, second)
                * linear.base.HODGE
                * coframe_wedge_first(coframe, variation, c, d)
            )
    return truncate_matrix(result)


def response(
    face: sp.Matrix,
    transport: GroupJet,
    probe: sp.Matrix,
    holonomy: GroupJet,
) -> sp.Expr:
    adjoint = matrix_product(
        transport.matrix,
        linear.base.generator(probe),
        transport.inverse,
    )
    product = matrix_product(
        linear.base.generator(face), adjoint, holonomy.matrix
    )
    return truncate(-HALF * sp.trace(product))


def link_euler(
    connection: dict[tuple[int, int], GroupJet],
    coframes: dict[int, sp.Matrix],
    site: int,
    direction: int,
    component: int,
) -> sp.Expr:
    probe = sp.zeros(6, 1)
    probe[component] = 1
    first_branch = sum(
        response(
            complementary_face(coframes[site], direction, b),
            connection[site, direction],
            probe,
            plaquette(connection, site, direction, b),
        )
        for b in linear.DIRECTIONS
    )
    second_branch = 0
    for a in linear.DIRECTIONS:
        predecessor = linear.base.shift(a, site)
        second_branch += response(
            complementary_face(coframes[predecessor], a, direction),
            two_step(connection, predecessor, a, direction),
            probe,
            plaquette(connection, predecessor, a, direction),
        )
    third_branch = 0
    for a in linear.DIRECTIONS:
        holonomy = plaquette(connection, site, a, direction)
        third_branch += response(
            complementary_face(coframes[site], a, direction),
            holonomy * connection[site, direction],
            probe,
            holonomy,
        )
    fourth_branch = 0
    for b in linear.DIRECTIONS:
        predecessor = linear.base.shift(b, site)
        fourth_branch += response(
            complementary_face(coframes[predecessor], direction, b),
            two_step(connection, predecessor, direction, b),
            probe,
            plaquette(connection, predecessor, direction, b),
        )
    return truncate(first_branch + second_branch - third_branch - fourth_branch)


def coframe_euler(
    connection: dict[tuple[int, int], GroupJet],
    coframes: dict[int, sp.Matrix],
    site: int,
    internal: int,
    direction: int,
) -> sp.Expr:
    probe = sp.zeros(4)
    probe[internal, direction] = 1
    value = 0
    for a in linear.DIRECTIONS:
        for b in linear.DIRECTIONS:
            face_variation = complementary_face_first(
                coframes[site], probe, a, b
            )
            holonomy_increment = (
                plaquette(connection, site, a, b).matrix - I4
            )
            product = matrix_product(
                linear.base.generator(face_variation), holonomy_increment
            )
            value += -HALF * sp.trace(product)
    return truncate(value)


def nonlinear_euler_jet(
    first: sp.Matrix, second: sp.Matrix | None = None
) -> sp.Matrix:
    if second is None:
        second = sp.zeros(len(linear.VARIABLES), 1)
    first_links, first_coframes = vector_fields(first)
    second_links, second_coframes = vector_fields(second)
    connection = connection_jets(first_links, second_links)
    coframes = coframe_jets(first_coframes, second_coframes)
    equations = [
        link_euler(connection, coframes, site, direction, component)
        for site in linear.SITES
        for direction in linear.DIRECTIONS
        for component in linear.COMPONENTS
    ]
    equations.extend(
        coframe_euler(connection, coframes, site, internal, direction)
        for site in linear.SITES
        for internal in linear.INTERNAL
        for direction in linear.DIRECTIONS
    )
    return sp.Matrix(equations)


def coefficient(vector: sp.Matrix, degree: int) -> sp.Matrix:
    return vector.applyfunc(lambda entry: sp.expand(entry).coeff(PARAMETER, degree))


def sparse_entries(vector: sp.Matrix) -> list[tuple[int, sp.Expr]]:
    return [
        (index, vector[index])
        for index in range(vector.rows)
        if vector[index] != 0
    ]


def audit_mode(
    name: str,
    tangent: sp.Matrix,
    hessian: sp.Matrix,
    left_kernel: sp.Matrix,
) -> tuple[sp.Matrix, sp.Matrix | None]:
    jet = nonlinear_euler_jet(tangent)
    first = coefficient(jet, 1)
    quadratic = coefficient(jet, 2)
    assert first == hessian * tangent
    assert first == sp.zeros(first.rows, 1)
    compatibility = left_kernel.T * quadratic
    compatible = compatibility == sp.zeros(compatibility.rows, 1)
    print(
        f"{name}: quadratic nonzero={len(sparse_entries(quadratic))}, "
        f"compatible={compatible}"
    )
    if not compatible:
        print(f"  nonzero cokernel pairings: {sparse_entries(compatibility)}")
        return quadratic, None
    solution, parameters = hessian.gauss_jordan_solve(-2 * quadratic)
    solution = solution.subs({symbol: 0 for symbol in solution.free_symbols})
    assert hessian * solution == -2 * quadratic
    corrected = nonlinear_euler_jet(tangent, solution)
    assert coefficient(corrected, 1) == sp.zeros(hessian.rows, 1)
    assert coefficient(corrected, 2) == sp.zeros(hessian.rows, 1)
    print(
        f"  sparse second-order correction: {len(sparse_entries(solution))} / "
        f"{solution.rows}; parameters={parameters.rows}"
    )
    return quadratic, solution


def main() -> None:
    hessian = sp.Matrix(linear.joint_matrix())
    assert hessian == hessian.T
    left_basis = hessian.T.nullspace()
    left_kernel = sp.Matrix.hstack(*left_basis)
    plus, cross = modes.explicit_modes()
    assert hessian * plus == sp.zeros(hessian.rows, 1)
    assert hessian * cross == sp.zeros(hessian.rows, 1)
    sanity = sp.zeros(len(linear.VARIABLES), 1)
    sanity[0] = 1
    sanity[49] = 2
    sanity_first = coefficient(nonlinear_euler_jet(sanity), 1)
    assert sanity_first == hessian * sanity
    print("generic first-order mirror check: passed")
    print(
        f"joint Hessian rank={hessian.rank()}, nullity={left_kernel.cols}"
    )
    plus_quadratic, _ = audit_mode(
        "plus", plus, hessian, left_kernel
    )
    cross_quadratic, _ = audit_mode(
        "cross", cross, hessian, left_kernel
    )
    mixed_quadratic, _ = audit_mode(
        "plus+cross", plus + cross, hessian, left_kernel
    )
    polarization = mixed_quadratic - plus_quadratic - cross_quadratic
    print(
        "mixed polarized quadratic nonzero="
        f"{len(sparse_entries(polarization))}"
    )


if __name__ == "__main__":
    main()
