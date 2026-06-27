import Mathlib
import PhysicsSM.StandardModel.OneGenerationTable
import PhysicsSM.Draft.NullEdgeYukawaFlip
import PhysicsSM.Draft.NullEdgeYukawaGaugeAristotle

/-!
# H11: legal finite Dirac/Higgs blocks and the neutrino stress test

This draft is the Lean companion to the H11 strategy report
`AgentTasks/null-edge-gate-h-forbidden-operator-neutrino-audit.md`.

It packages, as kernel-checked **finite decidable bookkeeping**, the structural
core of the requested *absence theorem*:

> legal finite Dirac/Higgs blocks have the Standard Model block form and exclude
> leptoquark, wrong-hypercharge, and colored-Higgs blocks; right-handed
> neutrinos enter only as a flag, never as a solved mechanism.

## What this file *is*

A finite "Dirac/Higgs block" is modelled as a triple
`(src, tgt, higgs) : PhysicalMultiplet × PhysicalMultiplet × HiggsSlot`,
representing the bilinear `bar(src) · higgs · tgt` mass/Yukawa operator on the
doubled `L ⊕ R` chiral space of `NullEdgeForbiddenCountertermCodim` /
`NullEdgeSuperDiracBlockCore`.

`LegalFiniteDirac` is the conjunction of four *independent* clauses, each tied to
a single physical mechanism so that forbidden blocks vanish **for reasons, not by
deletion**:

* `ChiralityOdd`     — anticommutation with the `Γ_s` chirality grading
                        (`χ_E` / oddness of a null-edge Dirac term);
* `HyperchargeNeutral` — the `U(1)_Y` gauge clause (`Q = T₃ + Y/2` convention);
* `WeakSinglet`      — the `SU(2)_L` gauge clause (the product contains a singlet);
* `ColorSinglet`     — the `SU(3)_c` gauge clause (`3̄ ⊗ 3 ⊃ 1`, `1 ⊗ 1 ⊃ 1`).

Each clause is decidable, so every claim below is closed by `decide`.

## What this file is **not**

No Yukawa numerical values, no mixing angles, no derivation of the generation
number, no Gate C release, and no continuum claim.  `WeakSinglet` and
`ColorSinglet` are *parity/branching* surrogates for the genuine
representation-theoretic singlet count, adequate for this binary bookkeeping but
**not** a full tensor-product representation theory.  See the report for the
precise claim boundary.

## Relation to `NullEdgeForbiddenCountertermCodim`

That file proves the *grading-only* half: any odd operator has vanishing diagonal
(same-chirality) blocks, so a diagonal mass is forbidden by `Γ_s` alone.  Here
`ChiralityOdd` is exactly that clause, lifted to the labelled
multiplet/hypercharge level, and the file shows what the **other three** gauge
clauses add in order to upgrade "diagonal same-chirality mass is forbidden" to
"SM-legal blocks only".
-/

namespace PhysicsSM.Draft.NullEdgeLegalFiniteDirac

open PhysicsSM.StandardModel.OneGenerationTable
open PhysicsSM.Draft.NullEdgeYukawaGauge
open PhysicsSM.Draft.NullEdgeYukawaFlip

/-! ## The finite Dirac/Higgs block -/

/-- A Higgs insertion slot for a bilinear block: none (bare mass), the Higgs
doublet (`Y = +1`), or the conjugate Higgs (`Y = -1`). -/
inductive HiggsSlot where
  | nohiggs
  | higgs
  | conjugateHiggs
deriving DecidableEq, Repr

/-- Hypercharge carried by the Higgs slot (repo convention `Q = T₃ + Y/2`). -/
def HiggsSlot.hypercharge : HiggsSlot → ℚ
  | .nohiggs => 0
  | .higgs => 1
  | .conjugateHiggs => -1

/-- Weak `SU(2)_L` pattern of the Higgs slot. -/
def HiggsSlot.weakPattern : HiggsSlot → WeakPattern
  | .nohiggs => .singlet
  | .higgs => .doublet
  | .conjugateHiggs => .doublet

/-- A finite Dirac/Higgs block `bar(src) · higgs · tgt`. -/
structure DiracBlock where
  src : PhysicalMultiplet
  tgt : PhysicalMultiplet
  higgs : HiggsSlot
deriving DecidableEq, Repr

/-! ## The four legality clauses -/

/-- Number of `SU(2)_L` doublets among the three factors of a block.  A product
of `SU(2)` reps (dimensions in `{1,2}`) contains a singlet iff the number of
doublets is even (`2 ⊗ 2 ⊃ 1`, `2 ⊗ 1 = 2`, `1 ⊗ 1 ⊃ 1`). -/
def numDoublets (b : DiracBlock) : ℕ :=
  (if weakPatternOfMultiplet b.src = .doublet then 1 else 0)
  + (if b.higgs.weakPattern = .doublet then 1 else 0)
  + (if weakPatternOfMultiplet b.tgt = .doublet then 1 else 0)

/-- **`χ_E` / grading clause.**  The block flips chirality `L ↔ R`, i.e. it is
odd for `Γ_s`.  This is the labelled form of `odd_diag_*_zero` in
`NullEdgeForbiddenCountertermCodim`. -/
def ChiralityOdd (b : DiracBlock) : Prop := b.src.chirality ≠ b.tgt.chirality

/-- **`U(1)_Y` gauge clause.**  The total hypercharge of `bar(src) · higgs · tgt`
vanishes (the bar negates `src`'s hypercharge). -/
def HyperchargeNeutral (b : DiracBlock) : Prop :=
  -b.src.hypercharge + b.higgs.hypercharge + b.tgt.hypercharge = 0

/-- **`U(1)_Y` gauge clause for a Majorana (`J_F`, no-bar) coupling.**  A Majorana
block connects `src` to `tgt^c` *without* a bar on the source, so both
hypercharges add: the neutrality condition is `Y(src) + Y(higgs) + Y(tgt) = 0`.
For a bare same-multiplet Majorana mass this is `2·Y(src) = 0`, i.e. it is gauge
allowed **iff** the state is hypercharge-neutral.  This is *not* the same as
`HyperchargeNeutral`, which (carrying the bar) cancels trivially for `src = tgt`. -/
def MajoranaNeutral (b : DiracBlock) : Prop :=
  b.src.hypercharge + b.higgs.hypercharge + b.tgt.hypercharge = 0

/-- **`SU(2)_L` gauge clause.**  The weak product contains a singlet. -/
def WeakSinglet (b : DiracBlock) : Prop := Even (numDoublets b)

/-- **`SU(3)_c` gauge clause.**  `bar(src) · tgt` contains a colour singlet
(`3̄ ⊗ 3 ⊃ 1`, `1 ⊗ 1 ⊃ 1`); for the bar (particle–antiparticle) convention this
is exactly equality of colour patterns. -/
def ColorSinglet (b : DiracBlock) : Prop :=
  colorPatternOfMultiplet b.src = colorPatternOfMultiplet b.tgt

/-- **Legal finite Dirac/Higgs block.**  All four clauses hold. -/
def LegalFiniteDirac (b : DiracBlock) : Prop :=
  ChiralityOdd b ∧ HyperchargeNeutral b ∧ WeakSinglet b ∧ ColorSinglet b

instance (b : DiracBlock) : Decidable (ChiralityOdd b) :=
  inferInstanceAs (Decidable (_ ≠ _))
instance (b : DiracBlock) : Decidable (HyperchargeNeutral b) :=
  inferInstanceAs (Decidable (_ = _))
instance (b : DiracBlock) : Decidable (MajoranaNeutral b) :=
  inferInstanceAs (Decidable (_ = _))
instance (b : DiracBlock) : Decidable (WeakSinglet b) :=
  inferInstanceAs (Decidable (Even _))
instance (b : DiracBlock) : Decidable (ColorSinglet b) :=
  inferInstanceAs (Decidable (_ = _))
instance (b : DiracBlock) : Decidable (LegalFiniteDirac b) :=
  inferInstanceAs (Decidable (_ ∧ _ ∧ _ ∧ _))

/-- The Standard Model Yukawa block attached to a one-generation flip channel. -/
def blockOfFlip (v : YukawaFlip) : DiracBlock :=
  { src := v.leftMultiplet
    tgt := v.rightMultiplet
    higgs := match higgsInsertion v with
      | .higgs => .higgs
      | .conjugateHiggs => .conjugateHiggs }

/-! ## Theorem 1 — the SM Yukawa blocks are legal

The four physical one-generation Yukawa channels (charged lepton, down quark, up
quark, and the *Dirac* neutrino) are all `LegalFiniteDirac`.  These are the
blocks the predicate is meant to *keep*. -/

/-- **Theorem 1.**  Every one-generation Standard Model Yukawa flip is a legal
finite Dirac/Higgs block. -/
theorem legal_of_SM_yukawa (v : YukawaFlip) : LegalFiniteDirac (blockOfFlip v) := by
  cases v <;>
    refine ⟨by decide, ?_, by decide, by decide⟩ <;>
    · simp only [HyperchargeNeutral, blockOfFlip, YukawaFlip.leftMultiplet,
        YukawaFlip.rightMultiplet, higgsInsertion, HiggsSlot.hypercharge,
        PhysicalMultiplet.hypercharge]
      norm_num

/-! ## Theorem 2 — forbidden blocks vanish, each for an identified reason

The forbidden families are excluded by *named* clauses, not by omission:

* leptoquark `bar(L_L) · d_R`  — `ColorSinglet` fails (`1 ≠ 3̄ ⊗ 3` route): colour;
* wrong-Higgs up block `bar(Q_L) · H · u_R` — colour-, weak-, and chirality-legal
  but `HyperchargeNeutral` fails: the obstruction is purely `U(1)_Y` (the legal up
  Yukawa needs the *conjugate* Higgs, `legal_of_SM_yukawa .upQuark`);
* a colored-Higgs block is excluded by construction: every `HiggsSlot` is a colour
  singlet, so no block can carry colour through the scalar. -/

/-- **Theorem 2a (leptoquark, killed by colour alone).**  `bar(L_L) · d_R` is not
a colour singlet, hence not legal, for *every* Higgs slot — the obstruction is
`SU(3)_c` and is independent of the scalar insertion. -/
theorem leptoquark_forbidden_by_color (h : HiggsSlot) :
    ¬ ColorSinglet { src := .L_L, tgt := .d_R, higgs := h }
      ∧ ¬ LegalFiniteDirac { src := .L_L, tgt := .d_R, higgs := h } := by
  have hc : ¬ ColorSinglet { src := .L_L, tgt := .d_R, higgs := h } := by
    cases h <;> decide
  exact ⟨hc, fun hleg => hc hleg.2.2.2⟩

/-- **Theorem 2b (wrong-Higgs, killed by `U(1)_Y` alone).**  The up block with the
*wrong* (non-conjugate) Higgs, `bar(Q_L) · H · u_R`, satisfies the colour, weak,
and chirality clauses, yet fails `HyperchargeNeutral`.  The obstruction is purely
`U(1)_Y`: the legal up Yukawa is the conjugate-Higgs block. -/
theorem wrongHiggs_up_forbidden_by_U1 :
    ChiralityOdd { src := .Q_L, tgt := .u_R, higgs := .higgs }
      ∧ WeakSinglet { src := .Q_L, tgt := .u_R, higgs := .higgs }
      ∧ ColorSinglet { src := .Q_L, tgt := .u_R, higgs := .higgs }
      ∧ ¬ HyperchargeNeutral { src := .Q_L, tgt := .u_R, higgs := .higgs }
      ∧ ¬ LegalFiniteDirac { src := .Q_L, tgt := .u_R, higgs := .higgs } := by
  have hY : ¬ HyperchargeNeutral { src := .Q_L, tgt := .u_R, higgs := .higgs } := by
    simp only [HyperchargeNeutral, HiggsSlot.hypercharge, PhysicalMultiplet.hypercharge]
    norm_num
  exact ⟨by decide, by decide, by decide, hY, fun hleg => hY hleg.2.1⟩

/-! ## Theorem 3 — the neutrino decision table

The right-handed neutrino is treated as a **flag/branch**, never as a solved
mechanism.  The table separates the *gauge* clauses from the *grading/`J_F`*
clause.

| branch                  | block                         | status                                    |
|-------------------------|-------------------------------|-------------------------------------------|
| `ν_R` absent            | no `tgt = nu_R` block         | nothing to forbid; `M_D = M_R = 0`         |
| `ν_R`, Dirac only       | `bar(L_L) · H̄ · ν_R`          | **legal** (`legal_of_SM_yukawa .neutrino`) |
| `ν_R`, Majorana `M_R`   | `bar(ν_R) · ν_R` (`nohiggs`)  | **gauge-allowed but `Γ_s`-forbidden**      |
| seesaw `M_eff`          | composite `M_D M_R⁻¹ M_Dᵀ`    | second-order; only via the `J_F` `M_R` branch |

The Majorana row is the crisp separation requested: the block passes *all three
gauge clauses* (`Y = 0`, weak singlet, colour singlet) yet fails `ChiralityOdd`.
It is therefore forbidden by the chirality grading alone and can only be admitted
if a real structure `J_F` reinterprets `E_R → E_R^c` as an off-diagonal odd block
in the doubled space — a separate, non-canonical clause. -/

/-- The Dirac neutrino block (the `.neutrino` Yukawa flip). -/
abbrev diracNeutrinoBlock : DiracBlock := blockOfFlip .neutrino

/-- The bare Majorana block for the right-handed neutrino: `bar(ν_R) · ν_R`. -/
abbrev majoranaNeutrinoBlock : DiracBlock := { src := .nu_R, tgt := .nu_R, higgs := .nohiggs }

/-- **Theorem 3a (Dirac branch is legal).** -/
theorem diracNeutrino_legal : LegalFiniteDirac diracNeutrinoBlock := by
  refine ⟨by decide, ?_, by decide, by decide⟩
  simp only [diracNeutrinoBlock, blockOfFlip, YukawaFlip.leftMultiplet,
    YukawaFlip.rightMultiplet, higgsInsertion, HyperchargeNeutral,
    HiggsSlot.hypercharge, PhysicalMultiplet.hypercharge]
  norm_num

/-- **Theorem 3b (Majorana is gauge-allowed, for the right reason).**  Using the
*Majorana* (no-bar) hypercharge `MajoranaNeutral`, the bare `ν_R` Majorana block
satisfies all three gauge clauses: `2·Y(ν_R) = 0`, weak singlet, and colour
singlet.  This genuinely uses `Y(ν_R) = 0`, unlike the trivial bar cancellation. -/
theorem majoranaNeutrino_gauge_allowed :
    MajoranaNeutral majoranaNeutrinoBlock
      ∧ WeakSinglet majoranaNeutrinoBlock
      ∧ ColorSinglet majoranaNeutrinoBlock := by
  refine ⟨?_, by decide, by decide⟩
  simp only [majoranaNeutrinoBlock, MajoranaNeutral, HiggsSlot.hypercharge,
    PhysicalMultiplet.hypercharge]
  norm_num

/-- **Theorem 3c (Majorana is forbidden by the grading, not by gauge).**  The
Majorana block is *not* `ChiralityOdd`, hence not `LegalFiniteDirac`, even though
every gauge clause (`MajoranaNeutral`, weak, colour) holds.  The single failing
clause is the `Γ_s` grading: a Majorana mass needs the `J_F` real structure, it
is not a gauge obstruction. -/
theorem majoranaNeutrino_forbidden_by_grading_only :
    ¬ ChiralityOdd majoranaNeutrinoBlock
      ∧ ¬ LegalFiniteDirac majoranaNeutrinoBlock
      ∧ MajoranaNeutral majoranaNeutrinoBlock
      ∧ WeakSinglet majoranaNeutrinoBlock
      ∧ ColorSinglet majoranaNeutrinoBlock := by
  have hchir : ¬ ChiralityOdd majoranaNeutrinoBlock := by decide
  have hgauge := majoranaNeutrino_gauge_allowed
  exact ⟨hchir, fun h => hchir h.1, hgauge.1, hgauge.2.1, hgauge.2.2⟩

/-- **The `J_F` Majorana flag is gauge-open iff the state is hypercharge-neutral.**
For a right-handed multiplet `m`, the bare Majorana coupling `m ↔ m^c` passes the
weak and colour clauses unconditionally, and passes the Majorana `U(1)_Y` clause
*iff* `Y(m) = 0`.  So the `J_F` branch opens for `ν_R` (`Y = 0`) and stays
gauge-forbidden for every charged right-handed state — `M_R` is a flag, not a
mechanism. -/
theorem majorana_gauge_open_iff_hypercharge_zero (m : PhysicalMultiplet)
    (hm : m.chirality = .right) :
    (MajoranaNeutral { src := m, tgt := m, higgs := .nohiggs }
        ∧ WeakSinglet { src := m, tgt := m, higgs := .nohiggs }
        ∧ ColorSinglet { src := m, tgt := m, higgs := .nohiggs })
      ↔ m.hypercharge = 0 := by
  cases m <;>
    simp_all [MajoranaNeutral, WeakSinglet, ColorSinglet, numDoublets,
      HiggsSlot.weakPattern, HiggsSlot.hypercharge, PhysicalMultiplet.hypercharge,
      PhysicalMultiplet.chirality, weakPatternOfMultiplet, colorPatternOfMultiplet] <;>
    norm_num

/-! ## Seesaw as a second-order effective obstruction

The seesaw effective mass `M_eff = - M_D M_R⁻¹ M_Dᵀ` is never a primitive legal
block; it is a *second-order composite* of the legal Dirac mass `M_D` and the
`J_F`-conditional Majorana mass `M_R`.  In particular, if the Majorana branch is
off (`M_R = 0`) the seesaw mass vanishes: no `J_F` branch, no `M_eff`. -/

/-- **Seesaw requires the Majorana branch.**  With `M_R = 0` (no `J_F` Majorana
mass) the seesaw effective mass is identically zero. -/
theorem seesaw_requires_majorana_branch {g : Type*} [Fintype g] [DecidableEq g]
    (M_D M_R Meff : Matrix g g ℂ)
    (hMeff : Meff = - (M_D * M_R⁻¹ * M_D.transpose)) :
    M_R = 0 → Meff = 0 := by
  intro hR
  subst hR hMeff
  simp

end PhysicsSM.Draft.NullEdgeLegalFiniteDirac
