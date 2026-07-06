# Adversarial audit — `FiniteNielsenNinomiya.lean`

Namespace: `PhysicsSM.Draft.NullEdge.GateYM.FiniteNielsenNinomiya`.
Trust: **no `sorry`, no `axiom`, no `native_decide`, no `@[implemented_by]`.** All
four `decide` calls (`nodes4`, `chirality4_zero`, `chirality4_two`,
`signedNodeCount4_eq_zero`) are **kernel `decide`** — verified axiom set of the
headlines is `{propext, Classical.choice, Quot.sound}` with **no
`Lean.ofReduceBool`**, which is what `native_decide` would inject.

## Verdicts

**(1) `signed_sum_telescope` — TRIVIAL (name over-imports meaning).**
Statement: `∀ h : ZMod N → ℤ, ∑ p, (h (p+1) - h p) = 0`. `h` is a *free*
parameter with no link to `ChiralSym`, `gamma5`, `fCanon`, `naiveSin4`, or any
chirality. It is the generic telescoping-over-a-cyclic-group identity, true for
*any* `ℤ`-valued function, proved by `Fintype.sum_equiv (Equiv.addRight 1)`. The
"signed chirality sum = 0" reading is supplied entirely by the docstring/naming,
not by the proof. What is proved: a total difference telescopes to 0 on a finite
cyclic group. What the prose implies: the chirality-weighted zero count of a
chirally-symmetric symbol vanishes. The bridge (that `h` is the branch of a
chirally-symmetric Dirac symbol) is absent.

**(2) `signedNodeCount4_eq_zero` — WEAKER-THAN-NAMED (honest given the model, but
the model is stipulated).**
`naiveSin4 : ZMod 4 → ℤ := ![0,1,0,-1]` is a hand-written integer vector. It is
*not* derived from `sin(2π p/4)`, and *not* connected to `fCanon` (the file's
only actual analytic symbol). Positively: `chirality4 p = sgnZ (naiveSin4 (p+1) −
naiveSin4 (p−1))` is a genuine central-difference definition, and `nodes4`,
`chirality4_zero (=+1)`, `chirality4_two (=−1)`, `signedNodeCount4 (=0)` are all
honestly *computed from* `naiveSin4` — not independently hand-assigned. So it is
not a pure tautology on unrelated constants. But the chain "genuine naive
dispersion ⟹ these node values" is stipulated: nothing proves
`naiveSin4 = sin(2π·/4)` or ties the `p=2` doubler to a zero of `fCanon`/an actual
sine. `fCanon_eq_zero_iff` even proves the naive *forward-difference* symbol has a
**single** zero (at 0), i.e. the doubling lives only in the separately-defined
`naiveSin4`, never derived. Honest arithmetic about a chosen model, mislabeled as
computed from "the naive dispersion".

**(3) `odd_signedCount_impossible` — VACUOUS / WEAKER-THAN-NAMED.**
Statement: `(h : ZMod N → ℤ) → Odd (∑ p, (h (p+1) − h p)) → False`. By
`signed_sum_telescope` that sum is identically `0` for every `h`, so the
hypothesis `Odd 0` is **unsatisfiable for all inputs**. The theorem is therefore
just the contrapositive restatement of (1), proved by rewriting with (1) then
`simp`. The conclusion is literally `False`, not any formalization of "requires a
Wilson term / chirality-even term"; "necessity" and "Wilson term" appear only in
prose. It does **not** state "chiral symmetry ⟹ even signed count": there is no
`ChiralSym` hypothesis, no Dirac operator, no zero-count over a symbol — only an
abstract `h`. So the physics necessity claim is not formalized.

**(4) `winding_exists` / `winding` — SOUND.**
`winding_exists` honestly proves the arg-increment sum of a nowhere-zero `f` is
`2π·k` for some `k : ℤ` (real content: phases close up around the loop, via
`Complex.arg_div_coe_angle` + `Real.Angle`). `winding f := round(windingSum f /
2π)` is well-defined and `winding_eq` shows `windingSum f = 2π·winding f`. It is
**not** identically 0 by construction: e.g. `f p = exp(2πi p/N)` gives winding 1.
The file correctly never asserts winding = 0, and `winding`/`windingSum` are used
**nowhere downstream**, so nothing secretly assumes winding = 0. Honesty note in
the header is accurate.

**(5) `chiralSym_iff_offDiag` — SOUND.**
`ChiralSym D := gamma5 * D * gamma5 = -D`, which is equivalent to `{γ5,D}=0` since
`γ5²=1` (`gamma5_sq`): `γ5 D γ5 = −D ⟺ γ5 D = −D γ5 ⟺ γ5 D + D γ5 = 0`. With
`γ5 = diag(1,−1)`, conjugation flips off-diagonal signs (`gamma5_conj`), so `γ5 D
γ5 = −D` forces exactly `D 0 0 = 0 ∧ D 1 1 = 0`. Statement and both directions are
correct; `chiralSym_offDiag_form` gives the explicit off-diagonal form. Matches
`{γ5,D}=0` ⇒ off-diagonal.

**(6) Scope honesty — SOUND (minor caveat).**
Header and closing "Informal generalization" explicitly disclaim the 4D continuum
Nielsen–Ninomiya and mark the degree-theoretic argument out of scope; the winding
honesty note is correct. No theorem claims to prove doubling for the project's
actual Wilson–Dirac operator. Minor overreach only in prose: the
`signedNodeCount4_eq_zero` docstring ("You cannot have exact chiral symmetry and a
single un-doubled Weyl mode") states a general no-go that the *computation* on
`naiveSin4` does not establish.

**(7) Trust — SOUND.** No `sorry`/`axiom`/`native_decide`/`@[implemented_by]`;
all `decide` are kernel `decide` (no `Lean.ofReduceBool`).

## Biggest gap and fix

The single biggest gap: **the "no-go / necessity" content is never connected to
chiral symmetry.** The two engine theorems — `signed_sum_telescope` and
`odd_signedCount_impossible` — quantify over a free `h : ZMod N → ℤ` and are pure
cyclic-telescoping facts; the `N=4` instance runs on a stipulated integer vector
`naiveSin4` rather than on a chirally-symmetric symbol `D` or on `fCanon`. So
"chiral symmetry ⟹ signed chirality count = 0" is asserted by naming, not proved.

Exact fix: define the signed count *from* a chirally-symmetric `D : ZMod N →
Matrix (Fin 2) (Fin 2) ℂ` (via its off-diagonal branch `f = D · 0 1` and the
integer branch `h p = winding-type / arg-increment` of `f`), and prove the signed
zero-count equals `∑ p, (h(p+1) − h p)` so that `signed_sum_telescope` *forces* it
to 0. Then restate `odd_signedCount_impossible` with an explicit `ChiralSym (D p)`
hypothesis and a signed-count-of-`D` conclusion. Absent that, add a caveat that
`h` is an abstract branch and the theorems are the topological skeleton, not a
statement about `D`.

## Citation guidance

Safe to cite **only** as: *"the honest topological skeleton of the finite (1D)
Nielsen–Ninomiya no-go"*, i.e.
- `signed_sum_telescope` — boundaryless telescoping (any `ℤ`-branch on `ZMod N`);
- `winding_exists` / `winding` / `winding_eq` — well-defined integer winding, not
  forced to 0 (SSH honesty);
- `chiralSym_iff_offDiag` / `chiralSym_offDiag_form` / `gamma5_sq` — correct
  local chiral-symmetry algebra;
- `signedNodeCount4_eq_zero` — a fully kernel-checked signed count = 0 for the
  chosen `N=4` model `naiveSin4`.

Caveat to attach: it is **not** a proof that "chiral symmetry ⟹ even/zero signed
chirality count" for an actual Dirac symbol. `signed_sum_telescope` and
`odd_signedCount_impossible` are chirality-agnostic (free `h`;
`odd_signedCount_impossible` has an unsatisfiable hypothesis and concludes
`False`), and `naiveSin4` is stipulated, not derived from `sin(2π·/4)` or
`fCanon`. It is a strictly honest improvement over the `DoublingTurnPrice`
over-claim, but its headline "no-go + necessity" is broader than the formal
content.
