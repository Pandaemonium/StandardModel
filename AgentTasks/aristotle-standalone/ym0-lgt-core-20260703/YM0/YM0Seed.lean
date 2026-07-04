/-
YM0Seed.lean — ℤ₂ lattice gauge theory: the gauge-invariance core.

STATUS: DRAFT — **NOT KERNEL-CHECKED in this session** (no toolchain in the
sandbox). Grade: statement file with candidate proofs for the PKG-YM0-A
Aristotle package. Nothing here is [M] until it compiles no-sorry/no-axiom.

Design constraints:
  * Core Lean 4 only — no Mathlib. ℤ₂ is realized as `Bool` with `xor`
    (`false ↦ +1`, `true ↦ −1`), so the group inverse is the identity map
    and orientation bookkeeping is trivial. The general finite/compact-G
    version (inverses threaded through `hol`, Fintype sums for Z-invariance,
    Haar for compact G) is the Mathlib-facing package PKG-YM0-B.
  * Conventions pinned to Scripts/oracle/validate_lgt_core.py v0.1
    (C-1..C-3): links on ordered vertex pairs; plaquette based, CCW.
  * Where a `simp`/case-split proof might not close as written, an
    alternative tactic line is left in a comment for Aristotle.
-/

namespace YM0

/-- A ℤ₂ link field assigns a group element to every ORDERED pair of
vertices. (Multigraph edges are not needed for the invariance theorems;
the lattice instance factors through this.) -/
def LinkField (V : Type) : Type := V → V → Bool

variable {V : Type}

/-- Gauge action: `(g · U) x y = g x * U x y * (g y)⁻¹`; for ℤ₂, xor. -/
def gauge (g : V → Bool) (U : LinkField V) : LinkField V :=
  fun x y => g x ^^ (U x y ^^ g y)

/-- Endpoint of the walk that starts at `x` and visits `w` in order. -/
def walkEnd (x : V) : List V → V
  | []      => x
  | y :: w  => walkEnd y w

/-- Holonomy of the walk `x :: w` (product of link variables along it). -/
def hol (U : LinkField V) : V → List V → Bool
  | _, []     => false
  | x, y :: w => U x y ^^ hol U y w

/-- **L2a (telescoping).** A gauge transformation changes a walk holonomy
only by the boundary factor `g x * g (walkEnd x w)`. This is the single
load-bearing induction; everything else is a corollary. -/
theorem hol_gauge (g : V → Bool) (U : LinkField V) (x : V) (w : List V) :
    hol (gauge g U) x w = (g x ^^ (hol U x w ^^ g (walkEnd x w))) := by
  induction w generalizing x with
  | nil =>
      -- goal: false = g x ^^ (false ^^ g x), after normalizing
      -- `walkEnd x [] = x` so the case split sees both `g x` occurrences
      simp only [hol, walkEnd]
      cases g x <;> rfl
  | cons y w ih =>
      simp only [hol, walkEnd, gauge, ih y]
      -- xor shuffle: (gx ^^ (Uxy ^^ gy)) ^^ (gy ^^ (h ^^ ge))
      --            = gx ^^ ((Uxy ^^ h) ^^ ge)
      cases g x <;> cases g y <;> cases U x y <;>
        cases hol U y w <;> cases g (walkEnd y w) <;> rfl
      -- Aristotle alternative if the case split stalls:
      --   simp [Bool.xor_assoc, Bool.xor_comm, Bool.xor_left_comm,
      --         Bool.xor_self, Bool.xor_false, Bool.false_xor]

/-- **L2 (gauge invariance of closed-walk holonomy).** For ℤ₂ the holonomy
itself is invariant; for general `G` the corresponding statement is
invariance up to conjugation, hence invariance of class functions. -/
theorem hol_gauge_closed (g : V → Bool) (U : LinkField V) (x : V)
    (w : List V) (hcl : walkEnd x w = x) :
    hol (gauge g U) x w = hol U x w := by
  rw [hol_gauge, hcl]
  cases g x <;> cases hol U x w <;> rfl

/-- Plaquette holonomy, convention C-2 (based at `a`, counterclockwise). -/
def plaq (U : LinkField V) (a b c d : V) : Bool := hol U a [b, c, d, a]

/-- **L2′ (plaquette gauge invariance).** -/
theorem plaq_gauge (g : V → Bool) (U : LinkField V) (a b c d : V) :
    plaq (gauge g U) a b c d = plaq U a b c d :=
  hol_gauge_closed g U a [b, c, d, a] rfl

/-- **L4a.** The gauge transformations compose pointwise (a `(V → ℤ₂)`
action on configurations). -/
theorem gauge_comp (g h : V → Bool) (U : LinkField V) :
    gauge g (gauge h U) = gauge (fun v => g v ^^ h v) U := by
  funext x y
  simp only [gauge]
  cases g x <;> cases h x <;> cases g y <;> cases h y <;> cases U x y <;> rfl

/-- **L4b.** Each ℤ₂ gauge transformation is an involution. Together with
L4a this exhibits the orbit structure used by the (Mathlib-layer) proof
that the partition function is gauge invariant: `gauge g` is a bijection
of configuration space and the Boltzmann summand is invariant (L3). -/
theorem gauge_invol (g : V → Bool) (U : LinkField V) :
    gauge g (gauge g U) = U := by
  funext x y
  simp only [gauge]
  cases g x <;> cases g y <;> cases U x y <;> rfl

/-- Wilson-action data: a list of based plaquettes. The ℤ₂ action is
`S_β(U) = β Σ_p s_p` with `s_p = 1 − 2·(plaq bit)`; L3 below is the exact
pointwise content, and partition-function invariance follows at the
Mathlib layer from L3 + L4b (sum over a bijection). -/
def plaqSpins (U : LinkField V) (ps : List (V × V × V × V)) : List Bool :=
  ps.map (fun q => plaq U q.1 q.2.1 q.2.2.1 q.2.2.2)

/-- **L3 (action-summand invariance).** Every statistic of the plaquette
spin list — in particular `S_β` and any Wilson-loop insertion — is gauge
invariant configuration by configuration. -/
theorem plaqSpins_gauge (g : V → Bool) (U : LinkField V)
    (ps : List (V × V × V × V)) :
    plaqSpins (gauge g U) ps = plaqSpins U ps := by
  induction ps with
  | nil => rfl
  | cons q ps ih =>
      simp only [plaqSpins, List.map_cons] at ih ⊢
      rw [plaq_gauge, ih]

/- NOT in this seed (deliberately):
   * partition function and its invariance — needs Fintype/Finset sums
     (Mathlib), packaged as PKG-YM0-B together with the general-G version;
   * center symmetry and the Polyakov-loop order parameter — trivial for
     ℤ₂ (center = group), stated for general G in the freeze document §L5;
   * anything about measures, Haar, or expectation values. -/

end YM0
