# claude-mass-shell-projectors — the energy projectors Lambda± = (pslash ± m)/2m: mass splits positive/negative energy

## Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)

Complement the chiral (Weyl) projectors with the mass-shell (energy) projectors of the Dirac operator.
Where the chiral projectors `P_L,R = (1 -/+ gamma5)/2` split the spinor by CHIRALITY, the energy
projectors `Lambda± = (pslash ± m)/2m` split it by SIGN OF ENERGY on the mass shell -- and the mass `m`
is exactly what makes them well-defined (they are singular as `m -> 0`, matching that a massless spinor
has no rest frame / energy split, only chirality). Prove they are a complete pair of orthogonal
idempotents, grounding the Dirac-propagator structure `(pslash+m)` in the PhysLean gamma convention.

## The model (Dirac-rep gammas, real (t,z) plane -> rational 4x4)

PhysLean Dirac-rep `g0 = diag(1,1,-1,-1)`, `g3 = !![0,0,1,0; 0,0,0,-1; -1,0,0,0; 0,1,0,0]` (both REAL).
For a massive momentum in the (t,z) plane `pslash = E . g0 - kz . g3` (real 4x4). On shell `E^2 - kz^2 =
m^2` with `m != 0`. Energy projectors `Lp = (1/(2*m)) . (pslash + m . 1)`, `Lm = (1/(2*m)) . (m . 1 -
pslash)` (rational when `E,kz,m` rational).

## Targets (rational; Matrix.mul/trace + fin_cases/ring/norm_num; NO transcendental, NO Complex, NO nlinarith)

1. `pslash_sq`: `pslash * pslash = (E^2 - kz^2) . 1` (`= m^2 . 1` on shell). Uses `g0^2=1`, `g3^2=-1`,
   `g0*g3 + g3*g0 = 0` -- verify by `ext; fin_cases; simp [g0,g3,...]; ring`.
2. `projectors_complete`: `Lp + Lm = 1` (positive + negative energy exhaust the spinor). By `ext`/`ring`.
3. `projectors_idempotent` (payload): `Lp * Lp = Lp` and `Lm * Lm = Lm`, using `pslash^2 = m^2` and
   `E^2-kz^2=m^2`, `m != 0`: `Lp^2 = (pslash+m)^2/4m^2 = (pslash^2 + 2 m pslash + m^2)/4m^2 = (2m^2 + 2 m
   pslash)/4m^2 = (pslash+m)/2m = Lp`. By explicit matrix algebra + `field_simp`/`ring` (carry `m != 0`
   and the on-shell relation).
4. `projectors_orthogonal` (payload): `Lp * Lm = 0` and `Lm * Lp = 0` (`(pslash+m)(m-pslash)/4m^2 =
   (m^2 - pslash^2)/4m^2 = 0`). Explicit.
5. `projector_ranks`: `Matrix.trace Lp = 2` and `Matrix.trace Lm = 2` (two positive- and two negative-
   energy states -- `tr pslash = 0`, so `tr Lp = (0 + 4m)/2m = 2`). By `trace` + `norm_num`.
6. `massless_singular` (the honest mass-role contrast): `Lambda±` are DEFINED only for `m != 0` (the
   `1/2m` factor); state that `2 m . Lp = pslash + m . 1` stays finite as `m -> 0` while `Lp ~ 1/m`
   diverges -- so the energy split needs mass, unlike the chirality split (which survives `m=0`). Give
   `2 m . Lp = pslash + m . 1` as an identity (finite), and note the divergence honestly in the docstring.
7. `mass_shell_projector_verdict`: package -- `Lambda± = (pslash ± m)/2m` are a complete pair of
   orthogonal idempotents (`Lp+Lm=1`, `Lp^2=Lp`, `Lp Lm=0`, `tr Lp = tr Lm = 2`) splitting the Dirac
   spinor by sign of energy on the mass shell `pslash^2=m^2`; they are singular as `m -> 0`. Grounds the
   `(pslash+m)` Dirac-propagator numerator in the PhysLean gamma convention. Honest scope: real (t,z)
   avatar; provenance = PhysLean spaceTime.gamma; the energy split is [import] Dirac theory, finite here.

MANDATORY non-degeneracy: explicit on-shell witness `E=5, kz=3, m=4` (`m^2=16`, `pslash^2 = 16 . 1`,
`Lp` a genuine projector with `tr = 2`); `Lp != 0`, `Lp != 1`. All in-theorem.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only (PhysLean is a REFERENCE).
Footprint exactly [propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in
#print axioms <thm>` on every headline. Rational 4x4 (real g0,g3 -> no Complex); Matrix.mul/trace +
fin_cases/ring/norm_num/field_simp (carry m != 0); NO Real.sqrt/cos/sin, NO Complex, NO nlinarith. Build
under 4 min (4x4 rational). Deliver RequestProject/Main.lean (namespace MassShellProjectors) +
ARISTOTLE_SUMMARY.md WITH the PhysLean provenance line.
