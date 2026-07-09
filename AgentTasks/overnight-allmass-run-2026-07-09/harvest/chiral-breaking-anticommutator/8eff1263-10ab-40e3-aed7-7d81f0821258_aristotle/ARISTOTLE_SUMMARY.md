# Summary of changes for run 8eff1263-10ab-40e3-aed7-7d81f0821258
Delivered `RequestProject/Main.lean` (namespace `ChiralBreakingAnticommutator`) plus `ARISTOTLE_SUMMARY.md`, building cleanly (no warnings) under Mathlib only, with no `sorry`/`admit`/`native_decide`/new axioms.

The Dirac-rep gammas of the (t,z) plane are realized as a rational 4×4 avatar (Q = ℚ, no Complex/transcendentals): `g5`, `g0 = diag(1,1,-1,-1)`, `g3`, `pslash E kz = E•g0 − kz•g3`, `D E kz m = pslash − m•1`, and chiral projectors `PL, PR`.

All eight targets are proved and kernel-checked:
1. `g5_anticommutes_g0`, 2. `g5_anticommutes_g3`, 3. `g5_anticommutes_pslash` (kinetic term flips chirality), 4. `g5_commutes_mass` (mass is chirality-even).
5. `chiral_breaking` (payload): `{g5, D} = (-2m)•g5`, proved from `{g5,pslash}=0` and `{g5,m•1}=2m•g5` with `module` for the scalar-smul bookkeeping.
6. `massless_chiral_symmetry` (payload): at m=0, `{g5, D}=0` (g5 anticommutes with the massless Dirac operator — chiral symmetry).
7. `mass_bilinear_couples_chirality` (companion): `PL*g0*PR = PL*g0` and `PL*g0*PR ≠ 0`.
8. `chiral_breaking_verdict` (verdict): the general law, its massless vanishing, `g5 ≠ 0`, and the mandatory explicit witnesses `{g5, D 5 3 4} = (-8)•g5` (nonzero breaking, via entry (0,2) = -8) and `{g5, D 5 3 0} = 0`.

Every headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …` confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`. `ARISTOTLE_SUMMARY.md` records the PhysLean gamma-provenance line and the honest reading: mass is the obstruction to g5 anticommuting with the Dirac operator (mass = chiral-symmetry breaking), a real (t,z) avatar of Dirac theory as finite kernel-checked matrix algebra. Work is committed and pushed.

# Chiral-symmetry breaking anticommutator: `{g5, D} = -2m·g5`

`RequestProject/Main.lean`, namespace `ChiralBreakingAnticommutator`. Mathlib only,
kernel-checked, no `sorry`/`admit`/`native_decide`/new axiom. Footprint on every
headline is exactly `[propext, Classical.choice, Quot.sound]` (verified in-file by
`#guard_msgs (whitespace := lax) in #print axioms <thm>`).

## Gamma-provenance (PhysLean reference, NOT an import)

The gamma matrices follow the standard Dirac representation used in PhysLean's Dirac
theory. Because the physics here lives in the real `(t,z)` plane, every matrix is real,
so the Dirac representation collapses to a **rational 4×4 avatar** (`Q := ℚ`, no
`Complex`, no transcendentals):

* `g5 = !![0,0,1,0; 0,0,0,1; 1,0,0,0; 0,1,0,0]` (block off-diagonal identity),
* `g0 = diag(1,1,-1,-1)`,
* `g3 = !![0,0,1,0; 0,0,0,-1; -1,0,0,0; 0,1,0,0]`,
* `pslash E kz = E • g0 - kz • g3` (Feynman slash in the `(t,z)` plane),
* `D E kz m = pslash E kz - m • 1` (the Dirac operator),
* `PL = (1/2)(1 - g5)`, `PR = (1/2)(1 + g5)` (chiral projectors).

## Results

1. `g5_anticommutes_g0`: `g5*g0 + g0*g5 = 0`.
2. `g5_anticommutes_g3`: `g5*g3 + g3*g5 = 0`.
3. `g5_anticommutes_pslash`: `g5*pslash + pslash*g5 = 0` — the kinetic term flips chirality.
4. `g5_commutes_mass`: `g5*(m•1) - (m•1)*g5 = 0` — the mass term is chirality-even.
5. `chiral_breaking` (**payload**): `g5*D + D*g5 = (-2m)•g5`, proved algebraically from
   `{g5,pslash}=0` and `{g5,m•1}=2m•g5`, with the scalar-smul bookkeeping closed by `module`.
6. `massless_chiral_symmetry` (**payload**): at `m=0`, `{g5, D(m=0)} = 0` — `g5`
   anticommutes with the massless Dirac operator `pslash`; this is chiral symmetry.
7. `mass_bilinear_couples_chirality` (companion): `PL*g0*PR = PL*g0` **and** `PL*g0*PR ≠ 0`
   — `g0` intertwines the two chiralities, so the Dirac mass bilinear `ψ̄ψ` couples L and R.
8. `chiral_breaking_verdict` (**verdict**): packages the general law, its massless
   vanishing, `g5 ≠ 0`, and the mandatory explicit witnesses
   `{g5, D 5 3 4} = (-8)•g5` (massive, genuinely nonzero breaking, shown via entry
   `(0,2) = -8`) and `{g5, D 5 3 0} = 0` (massless, chiral symmetry).

## Honest reading

Mass is precisely **the obstruction to `g5` anticommuting with the Dirac operator**,
measured by the anticommutator `{g5, D} = -2m·g5`. It vanishes exactly at `m=0`
(left/right decouple: chiral symmetry) and is nonzero for `m ≠ 0` (mass = chiral-symmetry
breaking). This is the algebraic core of the "mass comes from massless edges" thesis,
here a real `(t,z)` avatar of Dirac theory realized as finite, kernel-checked matrix
algebra.
