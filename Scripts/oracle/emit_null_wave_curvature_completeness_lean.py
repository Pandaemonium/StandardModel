"""Emit Lean certificate data for two-site curvature completeness.

The source matrix and row-space certificates are computed with exact SymPy
rationals from ``null_wave_linearized_backreaction.py``.  The emitted data are
not trusted evidence by themselves: the Lean successor proves that the matrix
rows equal the concrete action Euler coefficients and checks every certificate
identity by kernel normalization.

Run from the repository root:

    python Scripts/oracle/emit_null_wave_curvature_completeness_lean.py
"""

from __future__ import annotations

from pathlib import Path

import sympy as sp

import null_wave_linearized_backreaction as audit


OUTPUT = Path(
    "PhysicsSM/Draft/NullEdge/PeriodicVacuumWeylCurvatureCompletenessData.lean"
)


def lean_scalar(value: sp.Expr) -> str:
    value = sp.Rational(value)
    if value.q == 1:
        return str(value.p)
    return f"({value.p} / {value.q} : Real)"


def lean_index(variable: audit.Variable) -> str:
    if variable.kind == "A":
        return (
            f".link {variable.site} {variable.first} {variable.second}"
        )
    return f".coframe {variable.site} {variable.first} {variable.second}"


def lean_terms(terms: list[tuple[audit.Variable, sp.Expr]]) -> str:
    if not terms:
        return "[]"
    entries = [
        f"({lean_index(variable)}, {lean_scalar(coefficient)})"
        for variable, coefficient in terms
    ]
    return "[" + ", ".join(entries) + "]"


def nested_vector(values: object, indent: int = 2) -> str:
    if not isinstance(values, list):
        return str(values)
    if not values:
        return "[]"
    if all(not isinstance(value, list) for value in values):
        return "![" + ", ".join(str(value) for value in values) + "]"
    inner = [nested_vector(value, indent + 2) for value in values]
    pad = " " * indent
    child_pad = " " * (indent + 2)
    return "![\n" + child_pad + (",\n" + child_pad).join(inner) + "\n" + pad + "]"


def explicit_modes() -> tuple[sp.Matrix, sp.Matrix]:
    plus = sp.zeros(len(audit.VARIABLES), 1)
    cross = sp.zeros(len(audit.VARIABLES), 1)
    amplitude = {0: sp.Integer(1), 1: sp.Integer(-1)}
    cross_axis = sp.Matrix([-1, 0, 0, 0, 0, 0])
    for column, variable in enumerate(audit.VARIABLES):
        if variable.kind == "A":
            amp = amplitude[variable.site]
            if variable.first == 1:
                plus[column] = (-amp * audit.base.P1)[variable.second]
                cross[column] = (-amp * audit.base.P2)[variable.second]
            elif variable.first == 2:
                plus[column] = (-amp * audit.base.P2)[variable.second]
                cross[column] = (amp * audit.base.P1)[variable.second]
            elif variable.first in (0, 3):
                cross[column] = (amp * cross_axis)[variable.second]
        elif variable.site == 0:
            if (variable.first, variable.second) == (1, 1):
                plus[column] = -1
            elif (variable.first, variable.second) == (2, 2):
                plus[column] = 1
            elif (variable.first, variable.second) == (1, 2):
                cross[column] = 2
    return plus, cross


def build_data() -> tuple[list, list, list]:
    matrix = audit.joint_matrix()
    curvature = audit.curvature_matrix()
    plus, cross = explicit_modes()
    assert matrix * plus == sp.zeros(matrix.rows, 1)
    assert matrix * cross == sp.zeros(matrix.rows, 1)

    curvature_rows = {
        row: index for index, row in enumerate(audit.CURVATURE_ROWS)
    }
    plus_image = curvature * plus
    cross_image = curvature * cross
    plus_projection = (
        -sp.Rational(1, 2)
        * curvature[curvature_rows[0, 0, 1, 1], :]
    )
    cross_projection = (
        sp.Rational(1, 2)
        * curvature[curvature_rows[0, 0, 1, 2], :]
    )
    assert (plus_projection * plus)[0] == 1
    assert (plus_projection * cross)[0] == 0
    assert (cross_projection * plus)[0] == 0
    assert (cross_projection * cross)[0] == 1

    residual = (
        curvature
        - plus_image * plus_projection
        - cross_image * cross_projection
    )

    link_rows = []
    for site in audit.SITES:
        site_rows = []
        for direction in audit.DIRECTIONS:
            component_rows = []
            for component in audit.COMPONENTS:
                row = (site * 4 + direction) * 6 + component
                component_rows.append(
                    lean_terms(
                        [
                            (audit.VARIABLES[column], matrix[row, column])
                            for column in range(matrix.cols)
                            if matrix[row, column] != 0
                        ]
                    )
                )
            site_rows.append(component_rows)
        link_rows.append(site_rows)

    coframe_rows = []
    for site in audit.SITES:
        site_rows = []
        for internal in audit.INTERNAL:
            direction_rows = []
            for direction in audit.DIRECTIONS:
                row = 48 + (site * 4 + internal) * 4 + direction
                direction_rows.append(
                    lean_terms(
                        [
                            (audit.VARIABLES[column], matrix[row, column])
                            for column in range(matrix.cols)
                            if matrix[row, column] != 0
                        ]
                    )
                )
            site_rows.append(direction_rows)
        coframe_rows.append(site_rows)

    ordered_certificates: dict[tuple[int, int, int, int], list] = {}
    for site, first, second, component in audit.CURVATURE_ROWS:
        row = curvature_rows[site, first, second, component]
        right = residual[row, :].T
        if right == sp.zeros(matrix.cols, 1):
            terms = []
        else:
            solution, _ = matrix.T.gauss_jordan_solve(right)
            solution = solution.subs(
                {symbol: 0 for symbol in solution.free_symbols}
            )
            assert matrix.T * solution == right
            terms = [
                (audit.VARIABLES[index], solution[index])
                for index in range(solution.rows)
                if solution[index] != 0
            ]
        ordered_certificates[site, first, second, component] = terms

    certificates = []
    for site in audit.SITES:
        site_rows = []
        for first in audit.DIRECTIONS:
            first_rows = []
            for second in audit.DIRECTIONS:
                component_rows = []
                for component in audit.COMPONENTS:
                    if first < second:
                        terms = ordered_certificates[
                            site, first, second, component
                        ]
                    elif second < first:
                        terms = [
                            (variable, -coefficient)
                            for variable, coefficient in ordered_certificates[
                                site, second, first, component
                            ]
                        ]
                    else:
                        terms = []
                    component_rows.append(lean_terms(terms))
                first_rows.append(component_rows)
            site_rows.append(first_rows)
        certificates.append(site_rows)

    return link_rows, coframe_rows, certificates


def emit() -> str:
    link_rows, coframe_rows, certificates = build_data()
    return f"""import PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction

noncomputable section

/-!
# Generated exact certificate data for two-site curvature completeness

Generated by `Scripts/oracle/emit_null_wave_curvature_completeness_lean.py`
from the exact-rational audit matrix.  This data is not trusted as a proof:
`PeriodicVacuumWeylCurvatureCompleteness` checks the concrete action rows and
all row-space identities in Lean.
-/

namespace PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylCurvatureCompletenessData

open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave

/-- Common index for the 48 link and 32 coframe tangent/equation coordinates. -/
inductive NullWaveJointIndex where
  | link (site : NullWaveSite) (direction : Fin 4) (component : Fin 6)
  | coframe (site : NullWaveSite) (internal direction : Fin 4)
  deriving DecidableEq

/-- Sparse rows of the exact 48 by 80 link block of the joint Hessian. -/
def nullWaveLinkHessianTerms :
    NullWaveSite -> Fin 4 -> Fin 6 -> List (NullWaveJointIndex × Real) :=
  {nested_vector(link_rows)}

/-- Sparse rows of the exact 32 by 80 coframe block of the joint Hessian. -/
def nullWaveCoframeHessianTerms :
    NullWaveSite -> Fin 4 -> Fin 4 -> List (NullWaveJointIndex × Real) :=
  {nested_vector(coframe_rows)}

/-- Sparse row of the full joint Hessian. -/
def nullWaveJointHessianTerms :
    NullWaveJointIndex -> List (NullWaveJointIndex × Real)
  | .link site direction component =>
      nullWaveLinkHessianTerms site direction component
  | .coframe site internal direction =>
      nullWaveCoframeHessianTerms site internal direction

/-- Exact row-space certificates expressing every ordered curvature residual
after the two displayed polarization coordinates are removed. -/
def nullWaveCurvatureCertificateTerms :
    NullWaveSite -> Fin 4 -> Fin 4 -> Fin 6 ->
      List (NullWaveJointIndex × Real) :=
  {nested_vector(certificates)}

end PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylCurvatureCompletenessData
"""


def main() -> None:
    OUTPUT.write_text(emit(), encoding="utf-8", newline="\n")
    print(f"wrote {OUTPUT}")


if __name__ == "__main__":
    main()
