# C20 massive branch-lifting audit: `det(i D_+(q) + Gamma_s Phi_H)`

Provenance: Aristotle deliverable for Wave 9 job C20, 2026-06-26. Companion Lean
module: [`PhysicsSM/Draft/NullEdgeMassiveBranchLifting.lean`](../PhysicsSM/Draft/NullEdgeMassiveBranchLifting.lean).
Inputs: `PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean`,
`PhysicsSM/Draft/NullEdgeFlavoredChirality.lean`,
`PhysicsSM/Draft/NullEdgeSuperDiracSignAudit.lean`,
`PhysicsSM/Draft/NullEdgeSuperDiracSignBridge.lean`,
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` Sections 23-25.

This note answers C20: does a constant scalar or matrix `Phi_H` mass block lift,
preserve, or destabilize the high-momentum determinant-zero null branches that
Gate C currently classifies in the massless case. It records what was proved in
Lean (kernel-clean, no `s o r r y`, no `n a t i v e _ d e c i d e`), what is the
exact lifting condition, and what remains open before a *massive* Gate C release.

## 1. Setup and convention alignment

The flat retarded dual-soldered symbol gives, at corner `q`, a Clifford symbol
`p(q)` with Lorentzian square `p(q)^2 = TetrahedralNullBranch.qform (cornerU s)`
(mostly-minus, `docs/CONVENTIONS.md`). The massless determinant-zero branches are
exactly the corners with

```text
p(q) != 0   and   p(q)^2 = 0      (det c(p(q)) = 0).
```

`TetrahedralHighMomentumNullBranch` proves these are the one origin corner
(`k=0`, coefficient-zero) plus the four three-`pi` corners (`k=3`,
`qform = 0`, `cornerU != 0`): `count_highMomentumNull = 4`, `threePi_null`.

The massive test adds the Gate A mass term `Gamma_s Phi_H`. We model the Clifford
data abstractly with the locked Gate A spacetime relations
(`NullEdgeSuperDiracSignAudit`):

```text
(C1) Gamma_s^2 = 1
(C2) {Gamma_s, c(p)} = 0
(C3) c(p)^2 = p^2 . 1
```

For the matrix mass block we add the Gate A internal-mass convention
(`NullEdgeSuperDiracSignBridge`):

```text
(C4) [Gamma_s, Phi_H] = 0     (Phi_H is Gamma_s-even)
(C5) [c(p), Phi_H] = 0        (constant internal block, commutes with the symbol)
```

Per Gate A, `Phi_H` is `chi_E`-**odd** but `Gamma_s`-**even**; only (C4) (the
`Gamma_s`-even half) enters the square, which is why the mass block appears with
the physical `+Phi_H^2` sign rather than the tachyonic `-Phi_H^2`.

## 2. The finite algebra core (proved)

The full operator is `M = i c(p) + Gamma_s Phi_H`. Under the relations above the
square collapses to a single block:

* **Scalar mass** `Phi_H = m . 1`
  (`massive_square_scalar`):
  ```text
  M^2 = (m^2 - p^2) . 1.
  ```
* **Matrix mass** `Phi_H`
  (`massive_square_matrix`):
  ```text
  M^2 = Phi_H^2 - p^2 . 1.
  ```
  The cross term `i (c(p) Gamma_s Phi_H + Gamma_s Phi_H c(p))` cancels using
  (C2) and (C5); the mass block keeps `+Phi_H^2` using (C4) and (C1).

Taking determinants over `C` (an integral domain) turns these into exact
`det = 0` criteria, because `det(M)^2 = det(M^2)`:

* `massive_det_sq_scalar`: `det(M)^2 = (m^2 - p^2)^N`, `N = Fintype.card`.
* `massive_det_zero_iff_scalar` (`N >= 1`):
  `det M = 0  <->  m^2 = p^2`.
* `massive_det_zero_iff_matrix`:
  `det M = 0  <->  det(Phi_H^2 - p^2 . 1) = 0`.

## 3. Verdicts on the null branches (proved)

Specializing to a determinant-zero null branch (`p^2 = 0`, i.e. the three-`pi`
corners via `threePi_null`):

* `nullBranch_scalar_lifted`: for `m != 0`, `det M != 0`.
  **A nonzero constant scalar mass LIFTS every null branch.**
* `nullBranch_massless_preserved`: for `m = 0`, `det M = 0`.
  **The massless branch is PRESERVED (unchanged) at `m = 0`.**
* `nullBranch_matrix_lifted_iff`: `det M = 0  <->  det Phi_H = 0`.
  **A matrix mass block LIFTS the branch iff `Phi_H` is invertible; a zero mode
  of `Phi_H` SURVIVES as a branch singularity.**

Linked directly to the proven corners:

* `threePi_branch_scalar_lifted`: each of the four `k=3` corners is lifted by any
  `m != 0`.
* `threePi_branch_matrix_lifted_iff`: each `k=3` corner is lifted by `Phi_H` iff
  `det Phi_H != 0`.

Non-vacuity is witnessed by an explicit `2x2` gamma realization
(`nullSymbol = !![0,2;0,0]`, `chiralZ = sigma_z`): `nullSymbol^2 = 0` (so
`p^2 = 0`), `nullSymbol != 0`, `{chiralZ, nullSymbol} = 0`, and
`det(i nullSymbol + m chiralZ) = -m^2` (`witness_det_scalar`), nonzero exactly
for `m != 0` (`witness_scalar_lifted`), zero for `m = 0`
(`witness_massless_singular`).

## 4. Classification table

| branch `p^2`      | mass            | `M^2`            | `det M = 0  <=>`        | verdict                         |
|-------------------|-----------------|------------------|-------------------------|---------------------------------|
| `0` (null, `k=3`) | scalar `m != 0` | `m^2 . 1`        | never                   | **lifted**                      |
| `0` (null, `k=3`) | scalar `m = 0`  | `0`              | always                  | **preserved**                   |
| `0` (null, `k=3`) | matrix `Phi_H`  | `Phi_H^2`        | `det Phi_H = 0`         | **lifted iff `Phi_H` invertible** |
| `!= 0`            | scalar `m`      | `(m^2-p^2) . 1`  | `m^2 = p^2`             | conditional (mass-shell)        |
| any               | matrix `Phi_H`  | `Phi_H^2-p^2 .1` | `det(Phi_H^2-p^2.1)=0`  | conditional (shifted spectrum)  |

`complex/unstable` and `not-decidable-from-current-data` do not appear as
*algebraic* outcomes: at the determinant level the lifting question is fully
decided by the criteria above. Those two categories re-enter only at the
*physical* layer (Section 5), which the present finite algebra does not resolve.

## 5. What remains open before a massive Gate C release

The Lean results settle the algebraic determinant test but are explicitly
**necessary, not sufficient** for physical release (cf. working plan Section 23.6
steps 3-9, Section 25.3). Remaining blockers:

1. **Forced signs / convention (the standing Gate C blocker).** The relations
   (C1)-(C5) are *model inputs*. It is still not proved that the *full* flat
   null-edge operator forces `{Gamma_s, c(p)} = 0` and the Gate A mass
   convention at the high-momentum corners (this is the same "does the full
   operator force the modeled chirality/taste signs" blocker noted for the
   flavored-chirality mechanism). Next Lean target: derive (C2)-(C5) for the
   tetrahedral symbol from the dual-soldered construction rather than assuming
   them.

2. **Energy-slice real/complex classification.** `det M = 0` is solved in `q`,
   but the dispersion `q_0(q_space)` after an energy/momentum split, and whether
   the lifted/preserved branches sit at real or complex-conjugate-paired
   frequencies, is not addressed. Krein-pseudo-Hermitian spectra can be real or
   complex-paired (Feinberg-Riser); `M^2 = m^2 . 1` shows the *square* is real
   and positive for scalar `m`, but a Krein-signature computation of the
   eigenvectors is still required.

3. **Krein signature and doubled multiplicity.** No statement here about the
   `J`-norm sign of the surviving (matrix-mass zero-mode) branch eigenvectors.
   A Krein-negative survivor would be a ghost, not a physical pole.

4. **Matrix `Phi_H` realizability under `chi_E`-odd.** The matrix criterion
   `det M = 0 <-> det Phi_H = 0` is proved using only (C4),(C5). The Gate A
   `chi_E`-odd structure (`Phi_H` off-diagonal on `L (+) R`) was *not* needed for
   lifting, but it constrains which `Phi_H` are admissible and whether
   `det Phi_H != 0` is compatible with the forbidden-counterterm codimension
   result (`NullEdgeForbiddenCountertermCodim`). Next target: combine
   `nullBranch_matrix_lifted_iff` with the `chi_E`-odd block structure to decide
   whether an admissible Higgs/Yukawa block can be invertible on the branch
   subspace, or whether residual zero modes are forced (a potential
   internal-sector codimension statement, not a prediction yet).

5. **Counterterm inventory.** If lifting a branch with a matrix `Phi_H` requires
   tuning entries to keep `det Phi_H != 0`, those tunings enter the Gate F
   parameter ledger (working plan 23.3). Not addressed here.

6. **Comparison to minimally doubled fermions.** The scalar-mass result
   (`m^2 - p^2` mass shell) is the expected Wilson/mass-term behavior; a careful
   crosswalk to Boricci-Creutz / Karsten-Wilczek species-splitting masses and
   their counterterm obligations (Misumi 2025, Weber 2023/2025) is still a
   reading/comparison task, not formalized.

## 6. One-line Gate C verdict (massive layer)

```text
PENDING. Algebraic lifting fully decided: a scalar mass m != 0 lifts every
null branch; a matrix Phi_H lifts iff it is invertible on the branch (zero modes
survive). Physical release still blocked by sign-forcing (C2-C5), energy-slice
real/complex split, Krein signature, chi_E-odd admissibility of an invertible
Phi_H, and the counterterm ledger.
```

## 7. Axiom / soundness audit

All theorems in `NullEdgeMassiveBranchLifting.lean` depend only on
`propext, Classical.choice, Quot.sound` (verified with `#print axioms`). No
`a x i o m`, `s o r r y`, `a d m i t`, or `n a t i v e _ d e c i d e`. The module
builds under the pinned toolchain `leanprover/lean4:v4.28.0` with
`lake build PhysicsSM.Draft.NullEdgeMassiveBranchLifting`.

Convention dependencies are explicit hypotheses, not hidden assumptions: every
theorem carries (C1)-(C3) (and (C4),(C5) for the matrix case) as named
hypotheses, and the linkage theorems take the corner data `cornerCount s = 3`
and `Dp^2 = qform(cornerU s) . 1` explicitly. The Clifford relations are realized
non-vacuously by the explicit `2x2` witness.
