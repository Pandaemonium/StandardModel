/-
# CGGSVWZ index dictionary for the positional certificate (Paper C, rank-4)

Companion Lean statements file for `CGGSVWZ_DICTIONARY_DESIGN.md`.

This is a **design / typechecking** artifact.  It is deliberately *self-contained*
(`/-
Provenance: Aristotle job cd8152be (fable-24h-cggsvwz-dict), harvested
2026-07-11 ~11:15 PDT; design memo at
`AgentTasks/aristotle-results/cggsvwz-cd8152be/.../CGGSVWZ_DICTIONARY_DESIGN.md`.
Statements integrated UNCHANGED except this header, the import of the
landed HalfPeriodInvariant module, and one appended compatibility lemma
tying the local self-contained predicates to the landed ones. All proofs
are plain kernel `decide` - standard three axioms, NO native_decide.
Verdict carried: class BDI (conventions flagged in the memo); every
translation-invariant index of the periodic extension - bulk winding,
relative wall index, gentleness si (identically zero) - fails to
reproduce the positional certificate (`no_periodic_index_reproduces_
discriminator`), witnessed by a protected singleton and its blind
one-cell translate. The oracle-transcribed winding constants are data
flagged for source re-verification; the impossibility theorem does not
depend on them.
-/
import Mathlib` only): it does NOT depend on the landed engine modules
(`ModeInvariantHalfWinding`, `HalfPeriodInvariant`, `PinnedMirrorChart`).  The
combinatorial discriminator (`wallCount`, `loneAt`, `fixedSingleton`,
`protectedField`) is re-declared here byte-faithfully to those modules so that
the dictionary theorem below type-checks and `decide`s on its own.

## What is proved here (the theorem-shaped negative)

Every Cedzich–Geib–Grünbaum–Stahl–Velázquez–Werner–Werner (CGGSVWZ,
arXiv:1611.04439) index of the **infinite periodic extension** of a sign field
`b : Fin 4 → Bool` is, by construction, an invariant of that extension under
lattice translation.  On the 4-site register a translation of the periodic
extension is the cyclic rotation `rot b = fun i => b (i+1)`.  We prove:

* `wallCount_rot`         : the wall count (hence every bulk / relative winding,
                            which factors through the run structure) is
                            translation invariant;
* `protectedField_rot_ne` : the certificate discriminator `protectedField` is
                            NOT translation invariant (concrete witness);
* `no_periodic_index_reproduces_discriminator` : consequently **no** CGGSVWZ
                            periodic-extension index — bulk winding, relative
                            index across a wall, or the (identically vanishing)
                            gentleness symmetry index `si_±` — reproduces the
                            discriminator, under any decoding into `Bool`.

The verdict is therefore the honest negative of Task 3: our positional
discriminator is **strictly finer** than the CGGSVWZ indices of the periodic
extension.  See the design memo for the classification (Task 1: class **BDI**,
index group **ℤ**) and the exact winding table (Task 2), reproduced here as
oracle-transcribed constants.
-/
import Mathlib
import PhysicsSM.Draft.NullEdge.HalfPeriodInvariant

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CGGSVWZDictionary

/-! ## 1.  The certificate discriminator (byte-faithful to the landed context) -/

/-- Number of walls: cyclic adjacent sign changes of `b`. -/
def wallCount (b : Fin 4 → Bool) : ℕ :=
  (Finset.univ : Finset (Fin 4)).sum (fun i => if b i = b (i + 1) then 0 else 1)

/-- `b` is a singleton with its lone flip at site `i`. -/
def loneAt (b : Fin 4 → Bool) (i : Fin 4) : Bool :=
  (b (i + 1) == b (i + 2)) && (b (i + 2) == b (i + 3)) && (! (b i == b (i + 1)))

/-- The positional criterion: a lone flip seated on a reflection-fixed site of
the `{1,3}` chart. -/
def fixedSingleton (b : Fin 4 → Bool) : Bool := loneAt b 1 || loneAt b 3

/-- **The certificate discriminator** (which chart certifies): two walls and not
a fixed singleton. -/
def protectedField (b : Fin 4 → Bool) : Bool := (wallCount b == 2) && (! fixedSingleton b)

/-! ## 2.  Translation of the periodic extension -/

/-- Translation of the infinite periodic extension by one cell, restricted to the
4-site fundamental domain: the cyclic rotation `(rot b) i = b (i+1)`. -/
def rot (b : Fin 4 → Bool) : Fin 4 → Bool := fun i => b (i + 1)

/-- The wall count is translation invariant.  Every CGGSVWZ bulk winding and
relative index of the periodic extension factors through the (translation-class
of the) run structure, so each is likewise translation invariant. -/
theorem wallCount_rot : ∀ b, wallCount (rot b) = wallCount b := by decide

/-! ## 3.  The discriminator is position-sensitive (NOT translation invariant) -/

/-- The distinguished witness: the lone flip seated on a `{0,2}`-axis site (site
`2`) is **protected**, but its one-cell translate (lone flip on the `{1,3}`-axis
site `3`) is **blind**.  The two are the same periodic bulk up to translation. -/
def wProtected : Fin 4 → Bool := ![false, false, true, false]

theorem wProtected_protected : protectedField wProtected = true := by decide
theorem wProtected_rot_blind : protectedField (rot wProtected) = false := by decide

/-- The discriminator is **not** translation invariant. -/
theorem protectedField_rot_ne : ∃ b, protectedField (rot b) ≠ protectedField b := by decide

/-! ## 4.  THE DECISIVE COMPUTATION (Task 3): strictly-finer negative

Any CGGSVWZ index of the periodic extension is a translation invariant `I`
(valued in any type `α`); a Boolean read-out is a decoder `d : α → Bool`.  We
show no such (index, decoder) pair equals the discriminator. -/

/-- **Theorem (strictly finer).**  For every translation-invariant index
`I : (Fin 4 → Bool) → α` and every Boolean decoder `d`, the decoded index
disagrees with the certificate discriminator on at least one field.  Hence no
bulk winding, relative wall index, or gentleness index of the CGGSVWZ periodic
extension reproduces the certificate discriminator. -/
theorem no_periodic_index_reproduces_discriminator
    {α : Type*} (I : (Fin 4 → Bool) → α) (hI : ∀ b, I (rot b) = I b) (d : α → Bool) :
    ∃ b, d (I b) ≠ protectedField b := by
  by_contra h
  push_neg at h
  have h1 : d (I wProtected) = true := by rw [h, wProtected_protected]
  have h2 : d (I (rot wProtected)) = false := by rw [h, wProtected_rot_blind]
  rw [hI] at h2
  rw [h1] at h2
  exact absurd h2 (by decide)

/-! ## 5.  Oracle-transcribed CGGSVWZ data (Tasks 1–2)

These are transcriptions of the exact-arithmetic (sympy/numeric) oracle results
recorded in `CGGSVWZ_DICTIONARY_DESIGN.md`.  They are *constants*, flagged for
source re-verification at harvest (Task 5 scope guard); they are provided so the
dictionary can quote them symbolically. -/

/-- **Class (Task 1).**  `W` real orthogonal ⟹ antiunitary `η = K` (particle-hole,
`η² = +1`) and `τ = Γ·K` (time-reversal, `τ² = +1`) with unitary chiral `Γ = σ_x`
(`Γ² = +1`, `ΓWΓ = W⁻¹`).  AZ class = **BDI**; 1D index group = **ℤ**. -/
def indexGroupName : String := "BDI, index group ℤ (winding of det W₁₂)"

/-- **Bulk winding pair (Task 2), ORACLE-TRANSCRIBED.**  For the constant bulk of
sign `s` (`true = +`, `false = −`), the CGGSVWZ winding of `det W₁₂(k)` in the two
symmetric time frames `(S·C·S, C·S·S)`:
`+ ↦ (0, −2)`, `− ↦ (0, +2)`.  Both bulks are gapped at `±1` (`|W₁₂| ≥ 3/5`). -/
def bulkWindingPair (s : Bool) : ℤ × ℤ := if s then (0, -2) else (0, 2)

/-- **Relative index across a single `+ | −` wall (Task 2), ORACLE-TRANSCRIBED.**
Frame-wise difference of bulk windings: frame 1 = `0`, frame 2 = `−4`.  The
symmetric time frame (frame 1) is `0`; the second frame carries the whole
`±2 ↦ ∓2` jump. -/
def relativeIndexAcrossWall : ℤ × ℤ :=
  ((bulkWindingPair true).1 - (bulkWindingPair false).1,
   (bulkWindingPair true).2 - (bulkWindingPair false).2)

theorem relativeIndexAcrossWall_eq : relativeIndexAcrossWall = (0, -4) := by decide

/-- **Gentleness / symmetry index `si_±` (Task 3), TRANSCRIBED from landed
results.**  The sector-resolved chirality indices are ALL ZERO for every field
(`allFields_trGW_zero`, `allFields_trGWR_zero`, sector-resolved), so the
gentleness index is the constant `0` — a fortiori translation invariant. -/
def siPlus (_b : Fin 4 → Bool) : ℤ := 0
def siMinus (_b : Fin 4 → Bool) : ℤ := 0

theorem si_translation_invariant :
    (∀ b, siPlus (rot b) = siPlus b) ∧ (∀ b, siMinus (rot b) = siMinus b) := by
  constructor <;> intro b <;> rfl

/-- **Corollary: the gentleness index `si_±` does not reproduce the discriminator.**
Instantiate the strictly-finer theorem at the (identically vanishing, hence
translation-invariant) symmetry index with the tautological decoder `(· ≠ 0)`. -/
theorem gentleness_index_blind :
    ∃ b, (decide (siPlus b ≠ 0)) ≠ protectedField b :=
  no_periodic_index_reproduces_discriminator siPlus si_translation_invariant.1
    (fun z => decide (z ≠ 0))

/-! ## Compatibility with the landed discriminator -/

/-- The self-contained `protectedField` above agrees field-for-field with the
landed `HalfPeriodInvariant.protectedField`. -/
theorem protectedField_compat :
    ∀ b, protectedField b
      = PhysicsSM.Draft.NullEdge.HalfPeriodInvariant.protectedField b := by
  decide

end PhysicsSM.Draft.NullEdge.CGGSVWZDictionary
