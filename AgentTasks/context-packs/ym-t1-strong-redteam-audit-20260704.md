# T1 zero-cut Wilson RP strong-tier semantic red-team audit

Scope: audit whether the Q1/T1 claim language matches the kernel-checked Lean
statements after commit `1acf4f2` (Route-B reflection convention, Aristotle
`e6e46e9f`). Authoritative sources: the Lean files and run notes. Build check:
`lake build ...WilsonReflectionPositivity` completes (8045 jobs, no errors).
Axiom footprint of both headline theorems is `[propext, Classical.choice,
Quot.sound]`; no `s o r r y`, no `n a t i v e _ d e c i d e`, no `a x i o m`,
no `implemented_by` in any inspected file.

## 1. Verdict

ACCEPT WITH CHANGES.

The two headline theorems are genuine, correctly stated, and honestly scoped.
The zero-cut baseline plus ensemble-identification tier is legitimately closed,
and the strengthened zero-cut claim (genuine two-plaquette ensemble weight, not
a merely-shaped substitute) is justified by
`doubledWilsonWeight_eq_ensembleWeight_mirrorConfig`. Full RP-LINK / cut-plaquette
reflection positivity is correctly NOT claimed. The only required changes are
small claim-language / label disambiguations plus one recommended Lean
statement to nail down the "combined" claim; none of these affect soundness.

## 2. Findings by severity

### F1 (informational, no defect) - the ensemble identification is real

`WilsonReflectionPositivity.doubledWilsonWeight_eq_ensembleWeight_mirrorConfig`
proves, for a unitary `rho` (`hmul`, `hone`, `hunit`):

    doubledWilsonWeight beta rho p0 a b
      = (PlaquetteEnsemble.weight (mirrorPair p0)
           (wilsonLocalWeight beta rho) (mirrorConfig a b) : C)

- Same object: the LHS `doubledWilsonWeight` is exactly the weight family fed to
  `doubled_wilson_reflectionForm_nonneg`, so the identification does attach to the
  headline RP-KER instance rather than to a look-alike.
- `mirrorPair p0 : Bool -> Plaquette (doubleLattice L0)` is the genuine two-plaquette
  family {positive lift `liftPlaquettePos p0`, genuine mirror
  `mirrorPlaquette (doubleReflection L0) (liftPlaquettePos p0)`}. It is NOT restricted
  to `PUnit`; `PUnit` appears only as the cut-config type `C` of `reflectionForm` in the
  separate `doubled_wilson_reflectionForm_nonneg`, which is exactly the honest "zero cut"
  statement.
- No hidden pre-inversion cheat. The negative side of `mirrorConfig a b` is genuinely the
  time-reflection inverse `b^{-1}` (see `mirrorConfig`, `hol_mirrorPlaquette_mirrorConfig`
  giving `(p0.hol b)^{-1}`). Equality with `wilsonLocalWeight (p0.hol b)` is discharged by
  unitary inversion-invariance (`wilsonLocalWeight_inv_of_unitary`), not by defining the
  weight pre-inverted. The `Bool` product order (`Fintype.prod_bool`, then `if`-splitting)
  is handled correctly and the final `ring` absorbs commutativity.
- The `: C` cast is real-to-complex on BOTH sides (`wilsonLocalWeightC` is
  `((wilsonLocalWeight ... : R) : C)` and `PlaquetteEnsemble.weight` is `R`-valued cast up);
  it is faithful, not a coercion sleight of hand.

Conclusion for Q1: yes, the theorem identifies the factorized weight used in
`doubled_wilson_reflectionForm_nonneg` with the genuine two-plaquette
`PlaquetteEnsemble.weight` at `mirrorConfig a b`, under the stated unitary hypotheses,
with no hidden restriction.

### F2 (informational, no defect) - Route-B convention is a sound involution

`ReflectionCore.reflectLinkField U e = (U (reflectE e))^{-1}` is proved involutive
(`reflectLinkField_involutive`, the two inverses cancel via `inv_inv` plus edge involution).
It correctly drives the same-group holonomy identities:
`ReflectionWalk.hol_mirrorWalk_eq_inv`, `PlaquetteReflection.hol_mirrorPlaquette_eq_inv`,
and `MirrorHolonomyResolution.hol_mirrorPlaquette_mirrorConfig` - all valued in `G`, no
`MulOpposite`. The N3 negative result (`MirrorHolonomyConjugation`) that killed the old
inverse-free (pure word-reversal) convention is respected: the fix is the honest group
inverse (a conjugacy-class invariant), consistent with
`ordinaryReversal_eq_p0Hol_inv`. Answer to Q2: yes on both counts.

### F3 (LOW - claim-language / label) - "STRONG-TIER-CLOSED" label is ambiguous

`AgentTasks/fourday-ym-run-2026-07-05/LEDGER.md` line 13 tags T1 status
`STRONG-TIER-CLOSED-...`. In this project "strong tier" is used two ways: (a) the
zero-cut ensemble-identification tier (closed), and (b) loosely near "cut-plaquette".
The same cell disambiguates ("zero-cut tier (baseline + strong/ensemble-identification) is
now FULLY closed; shocking tier ... remains open"), so it is not wrong, but the bare label
read out of context invites over-reading. Recommend relabeling to
`ZEROCUT-TIER-CLOSED (baseline+ensemble-id); CUT-PLAQUETTE(SHOCKING) OPEN` so the status
token itself cannot be misquoted as full RP-LINK.

### F4 (LOW - dead scaffolding from the MulOpposite migration) - `opLinkField`

`ReflectionWalk.lean` still defines `opLinkField` and `stepHol_opLinkField`
(the `MulOpposite G` bookkeeping device). After Route B these are no longer used by the
main identity path (`hol_mirrorWalk_eq_inv` is MulOpposite-free). This is not a semantic
defect and not an over-claim - just orphaned scaffolding whose docstring still frames the
walk-level target as `op (hol (theta U) w) = hol (op U) (mirrorWalk w)`, which is no longer
the theorem actually proved in that file. Recommend either deleting `opLinkField`/
`stepHol_opLinkField` or updating the module docstring's "correct first target" paragraph
so it does not describe a MulOpposite target the file no longer pursues. No `rhoOppositeInv`
remnants survive in `WilsonReflectionCompatibility.lean` (it now threads `hinv`/
`wilsonLocalWeight_inv_of_unitary` directly); the migration there is clean. Answer to Q5:
no semantic mismatch introduced by the migration; only the F4 stale docstring/dead def.

### F5 (LOW - missing "combined" theorem) - the strongest zero-cut claim is only implicit

The documents state (correctly) that combining
`doubledWilsonWeight_eq_ensembleWeight_mirrorConfig` with
`doubled_wilson_reflectionForm_nonneg` shows the ACTUAL doubled-lattice Wilson ensemble is
reflection positive at `mirrorConfig` configurations. That combined statement is true but is
NOT itself a named theorem; it is left to the reader to substitute the equality into the
form. This is the single place where prose currently outruns a single kernel-checked
statement. See section 4 for the exact statement to add.

### F6 (informational) - docs are otherwise synced and honest

`GateYM.lean` (WilsonReflectionPositivity entry, lines ~313-330), `DAY_1_REPORT.md`
(T1 bullet, Honest section), and `reflection-positivity-outline.md` all now say
"zero-cut baseline + ensemble-identification closed; cut-plaquette (shocking) OPEN" and
explicitly refuse "RP-LINK fully closed". This matches the Lean. No stale
`rhoOppositeInv`/`MulOpposite` over-claims remain in these docs. Answer to Q3: yes, the
boundary is honest. Answer to Q4: no residual over-claim beyond F3 (label) and F4
(one stale docstring paragraph).

## 3. Exact claim-language corrections needed

1. LEDGER.md T1 status token: replace `STRONG-TIER-CLOSED...` with, e.g.,
   `ZEROCUT-TIER-CLOSED(baseline+ensemble-id); CUT-PLAQUETTE(SHOCKING)-OPEN`.
   Keep the descriptive cell text (already correct).
2. `ReflectionWalk.lean` module docstring: the paragraph beginning
   "The correct first target records the order reversal in the opposite group:
   `op (hol (theta U) w) = hol (op U) (mirrorWalk w)`" describes the pre-Route-B target.
   Update it to state the actual proved identity `hol U (mirrorWalk w) =
   (hol (theta U) w)^{-1}` and note `opLinkField` is retained only as unused scaffolding
   (or remove that def).
3. Anywhere the phrase "strong tier" is used unqualified for T1, append "(zero-cut
   ensemble-identification, NOT cut-plaquette)".

No Lean theorem statement should be weakened; none of the above touches a `theorem`
signature.

## 4. Lean statement to add next (prevents future over-claiming)

Add a single named corollary making the combined claim explicit, so no future doc has to
assert it in prose:

    theorem doubled_wilson_ensembleWeight_reflectionForm_nonneg
        [Fintype (L0.LinkField (G := G))]
        (p0 : Plaquette L0)
        (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
        (hone : rho 1 = 1)
        (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
        (f : L0.LinkField (G := G) → PUnit → ℂ) :
        0 ≤ ReflectionPositivityKernel.reflectionForm
              (fun a (_ : PUnit) b =>
                (PlaquetteEnsemble.weight (mirrorPair p0)
                  (WilsonLocalWeight.wilsonLocalWeight beta rho)
                  (mirrorConfig a b) : ℂ)) f

Proof: rewrite the kernel pointwise by the symmetric equation
`doubledWilsonWeight_eq_ensembleWeight_mirrorConfig`, then apply
`doubled_wilson_reflectionForm_nonneg`. This binds the RP inequality directly to
`PlaquetteEnsemble.weight` (not the abstractly-shaped `doubledWilsonWeight`), which is the
strongest honest zero-cut statement and cannot be misread as cut-plaquette RP because it is
evaluated only at `mirrorConfig a b` on the zero-cut `doubleLattice`.

(Recorded here as a recommendation only; per the current run policy this red-team makes no
theorem/API edits.)

## 5. Recommended next Q1 step

Proceed to cut-plaquette geometry design, feeding the existing
`ReflectionPositivityKernel.cutKernel_posSemidef_of_mixture`. Concretely:
1. Extend `ReflectionDouble` to a cut-bearing lattice (cross edges / shared cut links
   between the two copies) so `C` is a genuine nontrivial cut-config type, not `PUnit`.
2. Build the shared-cut-variable Wilson weight and show the cut kernel is a nonnegative
   mixture (spectral decomposition of the one-plaquette kernel via
   `WilsonWeightPositivity.wilsonKernel_posSemidef` + Schur/Hadamard products), then
   discharge PSD through `cutKernel_posSemidef_of_mixture`.
3. Before that lands, add the F5 corollary (section 4) and apply the F3/F4 label/docstring
   fixes, so the closed zero-cut tier is stated as tightly in Lean as it is in prose.
Documentation cleanup (F3, F4) is cheap and should ride along; do not park.
