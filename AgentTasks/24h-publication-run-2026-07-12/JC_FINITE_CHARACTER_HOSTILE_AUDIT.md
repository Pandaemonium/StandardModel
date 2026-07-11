# Adversarial semantic audit — finite Jordan–Clifford phase character

**Auditor role:** hostile mathematical referee. No edits, no proofs performed.
**Material audited:** the three verbatim sources in the prompt
(SOURCE 1 finite character, SOURCE 2 five-mode bridge, SOURCE 3 trusted
unit-level representation).

**Audit-environment caveat (read first).** The delivered repository contains
only `RequestProject/Main.lean` (an empty `import Mathlib` shell). None of the
`PhysicsSM.*` modules that these sources import — hence none of the *trusted*
definitions the theorems reduce to (`centralPhase`, `weakCount`, `colorCount`,
`fockHypercharge6`, `multipletHypercharge6`, `toMultiplet`, `hypercharge6_matches`,
`standardKernelPower`, `standardKernelPower_injective`, `fermionCentralKernel`,
`fermionCentralKernel_eq_standardPowers`, `standard_generator_mem`,
`unitCoveringTripleImageGroupHom`, `sixUnitCoveringKernelElts`,
`unitKernelFamily_maps_to_one`, `CoveringKernelElt`, `coveringKernelElt_card`) —
are present. The audit below is therefore a *reading* of statement shapes,
scope, and internal consistency, plus what the `#print axioms` pins certify.
It is **not** a re-verification of the `decide` closures.

---

## 1. Verdict

**PASS WITH REQUIRED SCOPE EDITS.**

Every stated theorem matches its claimed shape, the module carries honest
scope disclaimers, the axiom pins certify transitive `sorry`-freedom, and the
positive/negative controls are non-degenerate. Two docstring phrases outrun
what their theorems actually distinguish and one convention point is invisible
from the delivered text; these require the scope edits in §2 (MEDIUM findings)
but do not invalidate any theorem.

---

## 2. Findings (HIGH / MEDIUM / LOW)

### HIGH
None. No vacuous theorem, no false-shape statement, no `sorry`, and no
`#print axioms` line exposes an axiom beyond `propext, Classical.choice,
Quot.sound`. Because `#print axioms` is transitive, the *entire dependency
closure* of the SOURCE 1/2 declarations is sorry-free (this is the strongest
single positive fact in the package).

### MEDIUM

- **`characterKernel_unique_unitCovering_witness`
  / `evenFockKernel_unique_unitCovering_witness` — uniform-conjunct
  telescoping.** The `ExistsUnique (fun m : Fin 6 => t = standardKernelPower m
  ∧ unitCoveringTripleImageGroupHom (…) = 1)` is genuinely proved, but its
  *unique* content is carried entirely by injectivity of `standardKernelPower`
  (the first conjunct pins `m`). The second conjunct
  `unitCoveringTripleImageGroupHom … = 1` is a **constant** fact holding for
  every `m` (it is `unitKernelFamily_maps_to_one m`, independent of `t`). Hence
  "unique matching witness that maps to identity" must not be read as "the
  identity-mapping *selects* the witness" or as a bijection-of-kernels /
  action-kernel statement — the identity image is non-distinguishing. Required
  scope edit: state in the docstring that uniqueness is uniqueness of the index
  `m`, and that "maps to identity" is a uniform property of the whole trusted
  family, not a per-label discriminator.

- **"maps to identity" is image-level, not representation-action-level.** In
  SOURCE 1/2 the identity claim is `unitCoveringTripleImageGroupHom (…) = 1`,
  i.e. the covering *image* pair `(α³g, α⁻²h) = (I₂, I₃)` in the image group.
  SOURCE 3 separately proves the genuine *linear-action* triviality
  (`kernelElt_actQubitPlusQutrit_eq_id`,
  `sixUnitCoveringKernelElts_actQubitPlusQutrit_eq_id` on `QubitPlusQutrit =
  ℂ² ⊕ ℂ³`) — but that representation is **never wired into** the character
  theorems. Required scope edit: the SOURCE 1 docstring phrase "maps to
  identity" should specify *image-level identity*, and must not be paraphrased
  as "acts trivially on the representation" in any manuscript sentence built
  from SOURCE 1 alone.

### LOW

- **Mod-6 kernel, not integer-hypercharge kernel (`phaseValue`).** `phaseValue`
  coerces `centralPhase … : Int` into `ZMod 6`, so the character sees the
  hypercharge phase only modulo six. `characterKernel` is therefore a
  *mod-6 phase* kernel; a label with nonzero integer `6Y` but `6Y ≡ 0 (mod 6)`
  would lie in the kernel. This is consistent with the stated scope ("phase
  exponent modulo six") but should never be reported as an integer-hypercharge
  kernel.

- **Convention `6Y = 3 N_W − 2 N_V` and "all-left" are not checkable from the
  delivered text.** The identity is encoded as
  `fockHypercharge6 S = centralPhase 0 0 1 (weakCount S) (colorCount S)`
  (SOURCE 2, `fockHypercharge6_eq_centralPhase`) with `N_W = weakCount`,
  `N_V = colorCount`. The precise signs (`+3`, `−2`) and the all-left
  chirality convention live inside the unshown `centralPhase` / `fockHypercharge6`
  / `toMultiplet` definitions. Internal cross-validation exists
  (`spinorTableHypercharge6_eq_centralPhase` via `hypercharge6_matches` ties it
  to the trusted one-generation multiplet table on the even sector), which is
  reassuring, but the literal `3 N_W − 2 N_V` sign convention is a **hidden
  assumption** relative to the audited text.

- **Redundant ascription (`phaseValue`).** The body `(centralPhase … : Int)`
  under a `: ZMod 6` return type is a harmless implicit `Int.cast`; cosmetic
  only.

---

## Positive controls verified as non-degenerate (for completeness)

- **Additive law with full wraparound — `phaseValue_add`.** `t + u` is
  componentwise `Fin 3 × Fin 2 × Fin 6` addition (mod 3 / mod 2 / mod 6). The
  `decide` ranges over all `36 × 36` label pairs, so wraparound in *all three*
  coordinates is exercised; the equation certifies that `centralPhase` is a
  homomorphism into `ZMod 6` in each center coordinate. The additive law is the
  intended modular center multiplication. ✔
- **All-16-occupation quantification — `characterKernel`.** `phaseCharacter t =
  0` is equality in `EvenOccupation → ZMod 6`; by funext this quantifies over
  every element of `{S : Finset (Fin 5) // S.card % 2 = 0}`, i.e. all `2⁴ = 16`
  even occupations, not six hand-picked bidegrees. `evenFockCentralKernel`
  likewise quantifies `∀ S, S.card % 2 = 0 → …`. ✔
- **Set equality, not cardinality — `characterKernel_eq_standardPowers`.** Both
  sides are `Finset CenterLabels`; it is genuine Finset equality within one
  type, with no cross-type identification. ✔
- **Non-trivial character.** `standard_generator_character_zero` ((1,1,1) ∈
  kernel) and `missing_su2_character_nonzero` ((1,0,1) ∉ kernel) together show
  the character is neither zero nor total; the near-miss flips exactly the
  `SU(2)` coordinate (1 → 0), so `SU(2)` is load-bearing. ✔
- **Center ordering.** `CenterLabels = Fin 3 × Fin 2 × Fin 6` fed to
  `centralPhase t.1 t.2.1 t.2.2` = `SU(3) × SU(2) × U(1)`, matching the standard
  center ordering. ✔
- **No sign bug in the `% 6` test.** `centralPhase … % 6 = 0` on `Int` is
  `6 ∣ centralPhase` for either sign (`Int.emod`), consistent with the
  `ZMod 6` cast used in SOURCE 1; the `decide` in
  `characterKernel_eq_evenFockCentralKernel` bridges the two. ✔

---

## 3. Exact strongest manuscript sentence earned

> On the finite additive group `Z₃ × Z₂ × Z₆` of `SU(3) × SU(2) × U(1)`
> center labels, the assignment of each label to its five-mode even-Fock
> hypercharge phase reduced modulo six is a non-trivial additive character;
> its kernel — quantified over all sixteen even occupations — is exactly the
> six diagonal standard center powers, and each such label corresponds to a
> unique index of the repository's trusted unit-level covering-kernel family
> whose covering **image** equals the identity `(I₂, I₃)`; the whole
> construction is machine-checked and sorry-free (axioms `propext`,
> `Classical.choice`, `Quot.sound` only).

Any strengthening beyond this sentence is unearned.

## 4. Exact statements that remain forbidden

- "This is the kernel of the continuous covering-group action on the complete
  spinor representation." (Nothing continuous is constructed; character is
  finite and mod-6.)
- "The finite center labels **are** the trusted covering-kernel type." (Only a
  unique index correspondence `Fin 6 → CoveringKernelElt` is given; the types
  are not identified — cf. the deliberately weak `z6_kernel_cardinality_alignment`,
  which is only a card = card statement.)
- "The six labels **act trivially on the (spinor / QubitPlusQutrit)
  representation**" *as a consequence of the character theorems*. (SOURCE 3
  proves an `id`-action fact independently; it is not connected to
  `phaseCharacter`. SOURCE 1 gives only image-level `= 1`.)
- "The weak/color split is derived from a Jordan flag / Jordan data." (Not
  constructed; `weakCount`/`colorCount` are imported occupation counters.)
- "The character kernel is the integer-hypercharge kernel." (It is a mod-6
  kernel.)
- "The `SU(2)`, `SU(3)`, `U(1)` center factors are individually derived rather
  than posited." (They are posited as `Fin 3 × Fin 2 × Fin 6`.)

## 5. Smallest next theorem lifting this to a representation-kernel result

Wire the finite phase character to the *linear action* already available in
SOURCE 3. Introduce the map `tripleOf : CenterLabels → UnitCoveringTriple`
sending each center label to its covering triple, and prove the kernel
equivalence

```lean
theorem phaseCharacter_ker_eq_repKer (t : CenterLabels) :
    phaseCharacter t = 0 ↔
      unitCoveringTripleQubitPlusQutritRepresentation (tripleOf t) = 1
```

(equivalently `actQubitPlusQutrit (tripleOf t) = id`). This upgrades the
current image-level `= 1` to a genuine *finite-dimensional linear
representation-kernel* statement on `ℂ² ⊕ ℂ³`. The subsequent, larger step —
replacing `Z₆` by the continuous `U(1)` factor and `UnitCoveringTriple` by the
continuous covering group with a topological/Lie action — is what would finally
license the currently forbidden "continuous covering-group representation
kernel" language.
