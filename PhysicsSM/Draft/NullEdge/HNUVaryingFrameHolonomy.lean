import PhysicsSM.Draft.NullEdge.ScheduleIndexedTransportCore
import PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification

/-!
# HNU varying-frame holonomy: composing the transport telescope with the HNU reflection list

This module **composes** two landed, unchanged live modules:

* the schedule-indexed varying-frame telescope of
  `PhysicsSM.Draft.NullEdge.ScheduleIndexedTransportCore`
  (`dressedProduct_telescope`, `dressedProduct_cycle`, `dressedProduct_cycle_of_commutes`), and
* the exact HNU reflection schedule and its central holonomy of
  `PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification`
  (`hnuRefls`, `hnu_holonomy : hnuRefls.prod = -1`, together with `altRefls`, `sigma1_ne_one`,
  `sigma1_ne_neg_one`).

Everything runs in the concrete invertible-frame group `G = (M2)ˣ` (the units of the `2×2` complex
matrix ring); "unitary frame" is the special case of an invertible frame with `star G = G⁻¹`, so the
theorems below cover the unitary case a fortiori.  Ordered products keep the
**rightmost-first / `List.prod`** convention of the two source modules: for a path in schedule order
the earliest substep sits on the right and acts first, and `bareProduct` of a path equals the
reverse-order product of its bare operators, chosen so that a path realizing the HNU schedule has
`bareProduct` value `hnuRefls.prod = -1` (**signs verified against `hnu_holonomy`**).

## What is proved

1. **Exact cyclic HNU theorem** (`hnu_cyclic_varying_frame_holonomy`).  For *any* cyclic schedule of
   invertible frames whose dressed bare steps have the exact HNU ordered holonomy
   (`bareProduct` value `= hnuRefls.prod`), the dressed product is the central element `-1`.  The
   proof exhibits the endpoint factors and the cyclic premise explicitly through the telescope, and
   uses that `-1` is central.  A concrete nonempty HNU witness (`hnu_cyclic_holonomy_witness`) shows
   the theorem is non-vacuous.

2. **Open-frame control** (`hnu_open_frame_control`, with the explicit matrix identity
   `dressed_val_open_telescope`).  An *open* (noncyclic) schedule carrying the exact HNU bare
   holonomy `-1` but whose frame does **not** return (`endFrame ≠ g0`) can read `+1`.  This is a
   pseudo-escape: it is not a physical periodic cycle, and closing the cycle forces `-1` again by
   theorem 1.  So dropping cyclicity is not a periodic escape.

3. **Active-link boundary** (`hnu_passive_no_flip`, `hnu_active_flip`, `active_link_boundary`).  No
   *passive* consistently transformed schedule (same HNU bare holonomy, cyclic frame) can change
   `-1` to `+1`.  Reaching `+1` requires an *active* change of at least one bare step / link datum
   (`hnu_active_flip`, a nondegenerate cyclic counterexample with nontrivial reflection links whose
   product is `+1`) or a break of the cycle endpoint condition (theorem 2).

No locality, single-species realization, anomaly inflow, or continuum-physics claim is made; all
statements are finite algebra over `(M2)ˣ`.  No new axioms and no compiled-evaluation shortcut
(`native_decide`) are used; build-enforced axiom guards are at the end of the file.
-/

open Matrix
open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.ScheduleIndexedTransportCore
open PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HNUVaryingFrameHolonomy

/-! ## Part A. Invertible lifts of the HNU reflections and central-element bookkeeping -/

/-- Lift an involutive matrix `s` (`s * s = 1`) to an invertible frame/link in `(M2)ˣ`. -/
def rU (s : M2) (h : s * s = 1) : (M2)ˣ := ⟨s, s, h, h⟩

@[simp] theorem rU_val (s : M2) (h : s * s = 1) : ((rU s h : (M2)ˣ) : M2) = s := rfl

/-- The value of the central unit `-1` is the ring element `-1`. -/
@[simp] theorem unit_neg_one_val : ((-1 : (M2)ˣ) : M2) = -1 := by
  rw [Units.val_neg, Units.val_one]

/-- `-1 ≠ 1` in the `2×2` complex matrix ring. -/
theorem neg_one_ne_one_M2 : (-1 : M2) ≠ 1 := by
  exact ne_of_apply_ne ( fun m => m 0 0 ) ( by norm_num )

/-- The eight HNU sector reflections lifted to invertible frames, in schedule order. -/
def hnuReflsU : List (M2)ˣ :=
  [rU (-σ1) (by rw [neg_mul_neg]; exact σ1_sq),
   rU (-σ3) (by rw [neg_mul_neg]; exact σ3_sq),
   rU (-σ2) (by rw [neg_mul_neg]; exact σ2_sq),
   rU σ3 σ3_sq,
   rU σ1 σ1_sq,
   rU (-σ3) (by rw [neg_mul_neg]; exact σ3_sq),
   rU σ2 σ2_sq,
   rU σ3 σ3_sq]

/-- The invertible lifts of the HNU reflections carry the exact HNU value list. -/
theorem hnuReflsU_map_val : hnuReflsU.map (fun u => (u : M2)) = hnuRefls := by
  convert rfl

/-- The ordered product of the HNU invertible frames has value the central `-1`
(signs verified against `hnu_holonomy`). -/
theorem hnuReflsU_prod_val : ((hnuReflsU.prod : (M2)ˣ) : M2) = -1 := by
  convert hnu_holonomy using 1

/-! ## Part B. Structural lemmas for `bareProduct`/`endFrame` on constructed paths -/

/-- `bareProduct` is the reverse-order product of the bare operators (rightmost-first convention). -/
theorem bareProduct_eq_reverse_prod {G : Type*} [Group G] (path : List (G × G)) :
    bareProduct path = ((path.map Prod.snd).reverse).prod := by
  induction path <;> simp +decide [ *, List.prod_cons ];
  · rfl;
  · rename_i p ps ih; exact ih ▸ rfl;

/-- A path whose every frame equals `g` returns its frame: `endFrame g = g`. -/
theorem endFrame_map_const {G : Type*} [Group G] (g : G) (bares : List G) :
    endFrame g (bares.map (fun s => (g, s))) = g := by
  induction bares <;> aesop

/-! ## Part C. The exact cyclic HNU varying-frame theorem -/

/-- **Exact cyclic HNU varying-frame holonomy.**  For any cyclic schedule of invertible frames whose
dressed bare steps have the exact HNU ordered holonomy (`bareProduct` value `= hnuRefls.prod`), the
dressed product is the central element `-1`.  The endpoint factors and cyclic premise enter through
the telescope `dressedProduct = endFrame · bareProduct · g0⁻¹`, and `-1` is central so the two
endpoint frames cancel. -/
theorem hnu_cyclic_varying_frame_holonomy
    (g0 : (M2)ˣ) (path : List ((M2)ˣ × (M2)ˣ))
    (hbare : ((bareProduct path : (M2)ˣ) : M2) = hnuRefls.prod)
    (hcycle : endFrame g0 path = g0) :
    ((dressedProduct g0 path : (M2)ˣ) : M2) = -1 := by
  have hg0 : (g0 : M2) * (-1 : M2) = (-1 : M2) * (g0 : M2) := by
    simp +decide [ mul_neg, neg_mul ];
  have hbareGroup : bareProduct path = (-1 : (M2)ˣ) := by
    exact Units.ext ( by rw [ hbare, hnu_holonomy ] ; exact unit_neg_one_val.symm );
  convert congr_arg Units.val ( dressedProduct_cycle_of_commutes g0 ( -1 ) path hcycle hbareGroup _ ) using 1;
  exact Units.ext hg0

/-- An explicit nonempty cyclic HNU schedule: HNU reflection links, all frames the identity. -/
def hnuCyclicPath : List ((M2)ˣ × (M2)ˣ) :=
  (hnuReflsU.reverse).map (fun s => ((1 : (M2)ˣ), s))

theorem hnuCyclicPath_bare :
    ((bareProduct hnuCyclicPath : (M2)ˣ) : M2) = hnuRefls.prod := by
  convert congr_arg Units.val ( bareProduct_eq_reverse_prod hnuCyclicPath ) using 1

theorem hnuCyclicPath_cycle : endFrame (1 : (M2)ˣ) hnuCyclicPath = (1 : (M2)ˣ) := by
  -- Apply the endFrame_map_const lemma with g = 1 and bares = hnuReflsU.reverse.
  apply endFrame_map_const

/-- **Non-vacuity of the cyclic theorem.**  The explicit HNU cyclic schedule has dressed product
`-1`. -/
theorem hnu_cyclic_holonomy_witness :
    ((dressedProduct (1 : (M2)ˣ) hnuCyclicPath : (M2)ˣ) : M2) = -1 :=
  hnu_cyclic_varying_frame_holonomy 1 hnuCyclicPath hnuCyclicPath_bare hnuCyclicPath_cycle

/-! ## Part D. Open-frame control (noncyclic is not a periodic escape) -/

/-- **Explicit matrix telescope** for the dressed product: the two endpoint frames straddle the
ordered bare holonomy.  This is the composed transport law read at the matrix level. -/
theorem dressed_val_open_telescope (g0 : (M2)ˣ) (path : List ((M2)ˣ × (M2)ˣ)) :
    ((dressedProduct g0 path : (M2)ˣ) : M2)
      = ((endFrame g0 path : (M2)ˣ) : M2) * ((bareProduct path : (M2)ˣ) : M2)
          * ((g0⁻¹ : (M2)ˣ) : M2) := by
  convert congr_arg Units.val ( dressedProduct_telescope g0 path ) using 1

/-- An explicit open (noncyclic) schedule carrying the exact HNU bare holonomy `-1`, whose frame
does not return. -/
def openWitnessPath : List ((M2)ˣ × (M2)ˣ) := [((-1 : (M2)ˣ), (-1 : (M2)ˣ))]

/-- **Open-frame control.**  The open witness has the exact HNU bare holonomy (`bareProduct` value
`= hnuRefls.prod = -1`), yet its frame does not return (`endFrame ≠ g0`) and its dressed product is
`+1`.  This is only a pseudo-escape: it is not a periodic cycle, and by
`hnu_cyclic_varying_frame_holonomy` closing the cycle would force `-1` again.  Hence dropping
cyclicity is not a physical periodic escape. -/
theorem hnu_open_frame_control :
    ((bareProduct openWitnessPath : (M2)ˣ) : M2) = hnuRefls.prod ∧
    endFrame (1 : (M2)ˣ) openWitnessPath ≠ (1 : (M2)ˣ) ∧
    ((dressedProduct (1 : (M2)ˣ) openWitnessPath : (M2)ˣ) : M2) = 1 := by
  simp +decide [ openWitnessPath, bareProduct, endFrame, dressedProduct ];
  convert hnu_holonomy;
  simp +decide [ eq_comm ];
  exact fun _ => ne_of_apply_ne ( fun m => m 0 0 ) ( by norm_num )

/-! ## Part E. The active-link boundary -/

/-- **Passive no-go.**  No passive consistently transformed schedule (exact HNU bare holonomy, cyclic
frame) can change `-1` to `+1`. -/
theorem hnu_passive_no_flip
    (g0 : (M2)ˣ) (path : List ((M2)ˣ × (M2)ˣ))
    (hbare : ((bareProduct path : (M2)ˣ) : M2) = hnuRefls.prod)
    (hcycle : endFrame g0 path = g0) :
    ((dressedProduct g0 path : (M2)ˣ) : M2) ≠ 1 := by
  convert neg_one_ne_one_M2 using 1;
  convert hnu_cyclic_varying_frame_holonomy g0 path hbare hcycle using 1

/-- An explicit **active** cyclic schedule: two nontrivial `σ1` reflection links, all frames the
identity.  Its bare holonomy is `+1` (a genuine change of link data away from the HNU schedule). -/
def activePath : List ((M2)ˣ × (M2)ˣ) :=
  [((1 : (M2)ˣ), rU σ1 σ1_sq), ((1 : (M2)ˣ), rU σ1 σ1_sq)]

/-- **Active flip (nondegenerate counterexample).**  With a periodic (cyclic) frame closure,
changing the bare link data from the HNU schedule (holonomy `-1`) to a nondegenerate pair of
nontrivial reflections whose product is `+1` flips the dressed product to `+1`.  So `+1` is reachable
only by an active change of at least one bare step / link datum. -/
theorem hnu_active_flip :
    endFrame (1 : (M2)ˣ) activePath = (1 : (M2)ˣ) ∧
    ((rU σ1 σ1_sq : (M2)ˣ) : M2) ≠ 1 ∧ ((rU σ1 σ1_sq : (M2)ˣ) : M2) ≠ -1 ∧
    ((bareProduct activePath : (M2)ˣ) : M2) = 1 ∧
    ((dressedProduct (1 : (M2)ˣ) activePath : (M2)ˣ) : M2) = 1 := by
  refine' ⟨ _, _, _, _, _ ⟩ <;> norm_num [ activePath, endFrame, bareProduct, dressedProduct ];
  · exact sigma1_ne_one
  · exact sigma1_ne_neg_one
  · exact σ1_sq
  · exact σ1_sq

/-- **The active-link boundary, bundled.**

* passive cyclic HNU schedules are pinned to `-1` (cannot flip);
* an active change of bare link data reaches `+1` under the same periodic closure;
* abandoning periodicity (open frame) also reaches `+1`, but is not a cycle. -/
theorem active_link_boundary :
    (∀ (g0 : (M2)ˣ) (path : List ((M2)ˣ × (M2)ˣ)),
        ((bareProduct path : (M2)ˣ) : M2) = hnuRefls.prod → endFrame g0 path = g0 →
        ((dressedProduct g0 path : (M2)ˣ) : M2) = -1) ∧
    ((dressedProduct (1 : (M2)ˣ) activePath : (M2)ˣ) : M2) = 1 ∧
    (endFrame (1 : (M2)ˣ) openWitnessPath ≠ (1 : (M2)ˣ) ∧
      ((dressedProduct (1 : (M2)ˣ) openWitnessPath : (M2)ˣ) : M2) = 1) := by
  refine ⟨fun g0 path hbare hcycle => hnu_cyclic_varying_frame_holonomy g0 path hbare hcycle,
    ?_, ?_, ?_⟩
  · exact (hnu_active_flip.2.2.2.2)
  · exact (hnu_open_frame_control.2.1)
  · exact (hnu_open_frame_control.2.2)

end PhysicsSM.Draft.NullEdge.HNUVaryingFrameHolonomy

/-!
## Build-enforced assumption-footprint guards

Each headline theorem depends only on a subset of Lean/Mathlib's standard three principles
(`propext`, `Classical.choice`, `Quot.sound`).  No new axioms and no compiled-evaluation shortcut
(`native_decide`, i.e. `Lean.ofReduceBool`) are used.
-/

open PhysicsSM.Draft.NullEdge.HNUVaryingFrameHolonomy in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUVaryingFrameHolonomy.hnu_cyclic_varying_frame_holonomy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms hnu_cyclic_varying_frame_holonomy

open PhysicsSM.Draft.NullEdge.HNUVaryingFrameHolonomy in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUVaryingFrameHolonomy.hnu_cyclic_holonomy_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms hnu_cyclic_holonomy_witness

open PhysicsSM.Draft.NullEdge.HNUVaryingFrameHolonomy in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUVaryingFrameHolonomy.dressed_val_open_telescope' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms dressed_val_open_telescope

open PhysicsSM.Draft.NullEdge.HNUVaryingFrameHolonomy in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUVaryingFrameHolonomy.hnu_open_frame_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms hnu_open_frame_control

open PhysicsSM.Draft.NullEdge.HNUVaryingFrameHolonomy in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUVaryingFrameHolonomy.hnu_passive_no_flip' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms hnu_passive_no_flip

open PhysicsSM.Draft.NullEdge.HNUVaryingFrameHolonomy in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUVaryingFrameHolonomy.hnu_active_flip' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms hnu_active_flip

open PhysicsSM.Draft.NullEdge.HNUVaryingFrameHolonomy in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUVaryingFrameHolonomy.active_link_boundary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms active_link_boundary
