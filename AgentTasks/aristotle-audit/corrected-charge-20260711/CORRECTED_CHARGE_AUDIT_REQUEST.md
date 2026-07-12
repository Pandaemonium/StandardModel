# Corrected 3+1 charge audit request

Read every supplied file verbatim. The intended claim chain is deliberately
narrow:

- `localCrossingCharge` is the sign of an explicitly supplied real `3 x 3`
  Jacobian, not a global winding or Chern number.
- Opposite `2 x 2` Weyl tangents have charges `+1` and `-1` under that API.
- The complete mass-admitting `4 x 4` Dirac block is algebraically deformable
  through invertible mass blends and therefore is not assigned either Weyl
  charge by this project.
- Global chiral splitting is a load-bearing extra hypothesis for transporting
  local Weyl charges across a Brillouin zone.
- A chirality-odd correction that preserves the desired constant and linear
  jets must begin beyond first order. The supplied coefficient projection file
  does not itself prove differentiability, an `O(|k|^2)` estimate, global root
  exclusion, or no doubling.

Produce `CORRECTED_CHARGE_AUDIT_REPORT.md` with:

1. findings ordered by severity;
2. theorem-by-theorem semantic readings;
3. every overclaim in the supplied memo or manuscript excerpt;
4. exact replacement wording;
5. the single smallest missing theorem that most strengthens the chain.

Treat a mathematically correct correction as a possible audit conclusion, but
do not infer topology from a matrix interpolation or a supplied determinant
sign. Do not edit the Lean sources.
