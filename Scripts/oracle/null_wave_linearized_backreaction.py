"""Exact Hessian audit for two-site link/coframe backreaction.

This external SymPy oracle linearizes both Euler sectors of the concrete
nonlinear Lorentz Palatini action at identity links and identity coframe on
the live two-site null-wave carrier.  It builds the exact rational 80 by 80
joint system:

* 48 Lorentz-link equations for 48 link-potential coordinates;
* 32 coframe/Einstein equations for 32 tetrad coordinates.

It then measures the curvature carried by the joint kernel.  A kernel vector
with nonzero additive plaquette curl is a candidate linearized backreaction
mode; a curvature-rank zero result is a no-go for this carrier at Hessian
order.  This script is exploratory evidence only.  Headline conclusions must
be proved independently in Lean.

Run from the repository root:

    python Scripts/oracle/null_wave_linearized_backreaction.py
"""

from __future__ import annotations

from dataclasses import dataclass

import sympy as sp

import null_wave_conformal_euler as base


SITES = range(2)
DIRECTIONS = range(4)
COMPONENTS = range(6)
INTERNAL = range(4)


@dataclass(frozen=True)
class Variable:
    kind: str
    site: int
    first: int
    second: int


LINK_VARIABLES = tuple(
    Variable("A", site, direction, component)
    for site in SITES
    for direction in DIRECTIONS
    for component in COMPONENTS
)
COFRAME_VARIABLES = tuple(
    Variable("H", site, internal, direction)
    for site in SITES
    for internal in INTERNAL
    for direction in DIRECTIONS
)
VARIABLES = LINK_VARIABLES + COFRAME_VARIABLES


def zero_link_field() -> dict[tuple[int, int], sp.Matrix]:
    return {
        (site, direction): sp.zeros(6, 1)
        for site in SITES
        for direction in DIRECTIONS
    }


def zero_coframe_field() -> dict[int, sp.Matrix]:
    return {site: sp.zeros(4) for site in SITES}


def basis_fields(
    variable: Variable,
) -> tuple[dict[tuple[int, int], sp.Matrix], dict[int, sp.Matrix]]:
    links = zero_link_field()
    coframes = zero_coframe_field()
    if variable.kind == "A":
        links[variable.site, variable.first][variable.second] = 1
    else:
        coframes[variable.site][variable.first, variable.second] = 1
    return links, coframes


def link_generator_field(
    links: dict[tuple[int, int], sp.Matrix], site: int, direction: int
) -> sp.Matrix:
    return base.generator(links[site, direction])


def plaquette_tangent(
    links: dict[tuple[int, int], sp.Matrix], site: int, first: int, second: int
) -> sp.Matrix:
    """First-order right-logarithmic plaquette tangent at identity links."""

    return base.generator(
        plaquette_coordinates(links, site, first, second)
    )


def plaquette_coordinates(
    links: dict[tuple[int, int], sp.Matrix], site: int, first: int, second: int
) -> sp.Matrix:
    return (
        links[site, first]
        + links[base.shift(first, site), second]
        - links[site, second]
        - links[base.shift(second, site), first]
    )


def two_step_tangent(
    links: dict[tuple[int, int], sp.Matrix], site: int, first: int, second: int
) -> sp.Matrix:
    return link_generator_field(links, site, first) + link_generator_field(
        links, base.shift(first, site), second
    )


@dataclass(frozen=True)
class LinearizedFields:
    link_generators: dict[tuple[int, int], sp.Matrix]
    plaquettes: dict[tuple[int, int, int], sp.Matrix]
    two_steps: dict[tuple[int, int, int], sp.Matrix]
    faces: dict[tuple[int, int, int], sp.Matrix]


def coframe_wedge_first(
    variation: sp.Matrix, first: int, second: int
) -> sp.Matrix:
    result = sp.zeros(6, 1)
    for component, (i, j) in enumerate(base.BIVECTOR_PAIRS):
        result[component] = (
            variation[i, first] * base.I4[j, second]
            + base.I4[i, first] * variation[j, second]
            - variation[i, second] * base.I4[j, first]
            - base.I4[i, second] * variation[j, first]
        )
    return result


def complementary_face_first(
    variation: sp.Matrix, first: int, second: int
) -> sp.Matrix:
    result = sp.zeros(6, 1)
    for c in DIRECTIONS:
        for d in DIRECTIONS:
            result += (
                sp.Rational(1, 2)
                * base.alternating(c, d, first, second)
                * base.HODGE
                * coframe_wedge_first(variation, c, d)
            )
    return result


def linearized_fields(
    links: dict[tuple[int, int], sp.Matrix],
    coframes: dict[int, sp.Matrix],
) -> LinearizedFields:
    link_generators = {
        (site, direction): link_generator_field(links, site, direction)
        for site in SITES
        for direction in DIRECTIONS
    }
    plaquettes = {
        (site, first, second): plaquette_tangent(
            links, site, first, second
        )
        for site in SITES
        for first in DIRECTIONS
        for second in DIRECTIONS
    }
    two_steps = {
        (site, first, second): two_step_tangent(
            links, site, first, second
        )
        for site in SITES
        for first in DIRECTIONS
        for second in DIRECTIONS
    }
    faces = {
        (site, first, second): complementary_face_first(
            coframes[site], first, second
        )
        for site in SITES
        for first in DIRECTIONS
        for second in DIRECTIONS
    }
    return LinearizedFields(link_generators, plaquettes, two_steps, faces)


def response_first(
    face_base: sp.Matrix,
    face_tangent: sp.Matrix,
    transport_tangent: sp.Matrix,
    probe: sp.Matrix,
    holonomy_tangent: sp.Matrix,
) -> sp.Expr:
    """First-order coefficient of one exact ordered response branch."""

    probe_generator = base.generator(probe)
    face_generator = base.generator(face_base)
    face_generator_tangent = base.generator(face_tangent)
    adjoint_tangent = (
        transport_tangent * probe_generator
        - probe_generator * transport_tangent
    )
    tangent = (
        face_generator_tangent * probe_generator
        + face_generator * adjoint_tangent
        + face_generator * probe_generator * holonomy_tangent
    )
    return sp.expand(-sp.Rational(1, 2) * sp.trace(tangent))


def link_euler_first(
    fields: LinearizedFields,
    site: int,
    direction: int,
    component: int,
) -> sp.Expr:
    probe = sp.zeros(6, 1)
    probe[component] = 1
    first_branch = 0
    for b in DIRECTIONS:
        first_branch += response_first(
            base.IDENTITY_FACES[direction, b],
            fields.faces[site, direction, b],
            fields.link_generators[site, direction],
            probe,
            fields.plaquettes[site, direction, b],
        )
    second_branch = 0
    for a in DIRECTIONS:
        predecessor = base.shift(a, site)
        second_branch += response_first(
            base.IDENTITY_FACES[a, direction],
            fields.faces[predecessor, a, direction],
            fields.two_steps[predecessor, a, direction],
            probe,
            fields.plaquettes[predecessor, a, direction],
        )
    third_branch = 0
    for a in DIRECTIONS:
        holonomy = fields.plaquettes[site, a, direction]
        third_branch += response_first(
            base.IDENTITY_FACES[a, direction],
            fields.faces[site, a, direction],
            holonomy + fields.link_generators[site, direction],
            probe,
            holonomy,
        )
    fourth_branch = 0
    for b in DIRECTIONS:
        predecessor = base.shift(b, site)
        fourth_branch += response_first(
            base.IDENTITY_FACES[direction, b],
            fields.faces[predecessor, direction, b],
            fields.two_steps[predecessor, direction, b],
            probe,
            fields.plaquettes[predecessor, direction, b],
        )
    return sp.expand(
        first_branch + second_branch - third_branch - fourth_branch
    )


def coframe_probe(internal: int, direction: int) -> sp.Matrix:
    result = sp.zeros(4)
    result[internal, direction] = 1
    return result


PROBE_FACE_TANGENTS = {
    (internal, direction, a, b): complementary_face_first(
        coframe_probe(internal, direction), a, b
    )
    for internal in INTERNAL
    for direction in DIRECTIONS
    for a in DIRECTIONS
    for b in DIRECTIONS
}


def coframe_euler_first(
    fields: LinearizedFields,
    site: int,
    internal: int,
    direction: int,
) -> sp.Expr:
    value = 0
    for a in DIRECTIONS:
        for b in DIRECTIONS:
            face_tangent = PROBE_FACE_TANGENTS[internal, direction, a, b]
            value += -sp.Rational(1, 2) * sp.trace(
                base.generator(face_tangent)
                * fields.plaquettes[site, a, b]
            )
    return sp.expand(value)


def joint_equations(
    links: dict[tuple[int, int], sp.Matrix],
    coframes: dict[int, sp.Matrix],
) -> tuple[sp.Expr, ...]:
    fields = linearized_fields(links, coframes)
    link_rows = tuple(
        link_euler_first(fields, site, direction, component)
        for site in SITES
        for direction in DIRECTIONS
        for component in COMPONENTS
    )
    coframe_rows = tuple(
        coframe_euler_first(fields, site, internal, direction)
        for site in SITES
        for internal in INTERNAL
        for direction in DIRECTIONS
    )
    return link_rows + coframe_rows


def joint_matrix() -> sp.SparseMatrix:
    entries: dict[tuple[int, int], sp.Expr] = {}
    for column, variable in enumerate(VARIABLES):
        equations = joint_equations(*basis_fields(variable))
        for row, value in enumerate(equations):
            if value != 0:
                entries[row, column] = value
    return sp.SparseMatrix(len(VARIABLES), len(VARIABLES), entries)


CURVATURE_ROWS = tuple(
    (site, first, second, component)
    for site in SITES
    for first in DIRECTIONS
    for second in range(first + 1, 4)
    for component in COMPONENTS
)

PAIR_ROWS = tuple(
    (site, a, b, i, j)
    for site in SITES
    for a in DIRECTIONS
    for b in DIRECTIONS
    for i in INTERNAL
    for j in INTERNAL
)

BIANCHI_ROWS = tuple(
    (site, a, b, c, d)
    for site in SITES
    for a in DIRECTIONS
    for b in DIRECTIONS
    for c in DIRECTIONS
    for d in DIRECTIONS
)


def curvature_matrix() -> sp.SparseMatrix:
    entries: dict[tuple[int, int], sp.Expr] = {}
    for column, variable in enumerate(VARIABLES):
        if variable.kind != "A":
            continue
        links, _ = basis_fields(variable)
        for row, (site, first, second, component) in enumerate(CURVATURE_ROWS):
            coordinate = plaquette_coordinates(
                links, site, first, second
            )[component]
            if coordinate != 0:
                entries[row, column] = coordinate
    return sp.SparseMatrix(len(CURVATURE_ROWS), len(VARIABLES), entries)


def lowered_curvatures(
    links: dict[tuple[int, int], sp.Matrix],
) -> dict[tuple[int, int, int], sp.Matrix]:
    return {
        (site, first, second):
            base.ETA
            * base.bivector_matrix(
                plaquette_coordinates(links, site, first, second)
            )
            * base.ETA
        for site in SITES
        for first in DIRECTIONS
        for second in DIRECTIONS
    }


def riemann_constraint_matrices() -> tuple[sp.SparseMatrix, sp.SparseMatrix]:
    pair_entries: dict[tuple[int, int], sp.Expr] = {}
    bianchi_entries: dict[tuple[int, int], sp.Expr] = {}
    for column, variable in enumerate(VARIABLES):
        if variable.kind != "A":
            continue
        links, _ = basis_fields(variable)
        lowered = lowered_curvatures(links)
        for row, (site, a, b, i, j) in enumerate(PAIR_ROWS):
            value = lowered[site, a, b][i, j] - lowered[site, i, j][a, b]
            if value != 0:
                pair_entries[row, column] = value
        for row, (site, a, b, c, d) in enumerate(BIANCHI_ROWS):
            value = (
                lowered[site, a, b][c, d]
                + lowered[site, b, c][a, d]
                + lowered[site, c, a][b, d]
            )
            if value != 0:
                bianchi_entries[row, column] = value
    pair = sp.SparseMatrix(len(PAIR_ROWS), len(VARIABLES), pair_entries)
    bianchi = sp.SparseMatrix(
        len(BIANCHI_ROWS), len(VARIABLES), bianchi_entries
    )
    return pair, bianchi


def kernel_matrix(matrix: sp.Matrix) -> sp.Matrix:
    basis = matrix.nullspace()
    if not basis:
        return sp.zeros(matrix.cols, 0)
    return sp.Matrix.hstack(*basis)


def restrict_kernel(
    ambient_kernel: sp.Matrix, constraints: sp.Matrix
) -> sp.Matrix:
    coefficient_kernel = kernel_matrix(constraints * ambient_kernel)
    return ambient_kernel * coefficient_kernel


def null_wave_control() -> None:
    links = zero_link_field()
    links[1, 1] = base.P1
    links[1, 2] = base.P2
    equations = joint_equations(links, zero_coframe_field())
    expected = {
        (1, 1, 1): -2,
        (1, 1, 3): 2,
        (1, 2, 2): 2,
        (1, 2, 4): -2,
    }
    for site in SITES:
        for direction in DIRECTIONS:
            for component in COMPONENTS:
                row = (site * 4 + direction) * 6 + component
                assert equations[row] == expected.get(
                    (site, direction, component), 0
                )
    assert equations[48:] == (0,) * 32


def print_vector(label: str, vector: sp.Matrix) -> None:
    print(label)
    for variable, value in zip(VARIABLES, vector, strict=True):
        if value != 0:
            print(
                f"  {variable.kind}[{variable.site},{variable.first},"
                f"{variable.second}] = {value}"
            )


def print_curvature(vector: sp.Matrix, curvature: sp.Matrix) -> None:
    print("Nonzero independent curvature coordinates:")
    values = curvature * vector
    for row, value in zip(CURVATURE_ROWS, values, strict=True):
        if value != 0:
            site, first, second, component = row
            print(f"  F[{site},{first},{second},{component}] = {value}")


def independent_curvature_vectors(
    basis: sp.Matrix, curvature: sp.Matrix
) -> list[sp.Matrix]:
    selected: list[sp.Matrix] = []
    images = sp.zeros(curvature.rows, 0)
    current_rank = 0
    for vector in basis.columnspace():
        image = curvature * vector
        candidate = images.row_join(image)
        candidate_rank = candidate.rank()
        if candidate_rank > current_rank:
            selected.append(vector)
            images = candidate
            current_rank = candidate_rank
    return selected


def main() -> None:
    null_wave_control()
    matrix = joint_matrix()
    curvature = curvature_matrix()
    pair_constraints, bianchi_constraints = riemann_constraint_matrices()
    rank = matrix.rank()
    joint_kernel = kernel_matrix(matrix)
    pair_joint_kernel = restrict_kernel(joint_kernel, pair_constraints)
    riemann_joint_kernel = restrict_kernel(
        pair_joint_kernel, bianchi_constraints
    )
    curvature_on_kernel = curvature * joint_kernel
    curvature_on_riemann_kernel = curvature * riemann_joint_kernel
    curvature_rank = curvature_on_kernel.rank()
    riemann_curvature_rank = curvature_on_riemann_kernel.rank()

    print(f"joint Hessian rank: {rank} / {matrix.cols}")
    print(f"joint Hessian nullity: {joint_kernel.cols}")
    print(f"independent curvature rows: {curvature.rows}")
    print(f"pair-exchange constraint rank: {pair_constraints.rank()}")
    print(f"algebraic-Bianchi constraint rank: {bianchi_constraints.rank()}")
    print(f"curvature rank on joint kernel: {curvature_rank}")
    print(f"pair-symmetric joint-kernel dimension: {pair_joint_kernel.cols}")
    print(f"vacuum-Riemann joint-kernel dimension: {riemann_joint_kernel.cols}")
    print(
        "curvature rank on vacuum-Riemann joint kernel: "
        f"{riemann_curvature_rank}"
    )

    assert matrix * joint_kernel == sp.zeros(matrix.rows, joint_kernel.cols)
    assert pair_constraints * pair_joint_kernel == sp.zeros(
        pair_constraints.rows, pair_joint_kernel.cols
    )
    assert pair_constraints * riemann_joint_kernel == sp.zeros(
        pair_constraints.rows, riemann_joint_kernel.cols
    )
    assert bianchi_constraints * riemann_joint_kernel == sp.zeros(
        bianchi_constraints.rows, riemann_joint_kernel.cols
    )
    if curvature_rank == 0:
        print("No nonflat linearized joint mode exists on this carrier.")
        return

    for vector in joint_kernel.columnspace():
        if curvature * vector != sp.zeros(curvature.rows, 1):
            print_vector("First sparse nonflat joint-kernel vector:", vector)
            print_curvature(vector, curvature)
            break

    if riemann_curvature_rank == 0:
        print("All nonflat joint modes fail an algebraic Riemann condition.")
        return

    for index, vector in enumerate(
        independent_curvature_vectors(riemann_joint_kernel, curvature), start=1
    ):
        print_vector(
            f"Vacuum-Riemann curvature basis vector {index}:", vector
        )
        print_curvature(vector, curvature)


if __name__ == "__main__":
    main()
