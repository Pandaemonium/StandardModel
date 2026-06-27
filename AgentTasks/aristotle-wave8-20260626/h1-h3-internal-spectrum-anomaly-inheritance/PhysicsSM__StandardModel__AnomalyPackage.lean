import Mathlib.Tactic

/-!
# Standard Model anomaly cancellation package

This module provides a generic, kernel-checked framework for stating and
verifying gauge anomaly cancellation for the Standard Model gauge group
`SU(3)_c × SU(2)_L × U(1)_Y`.

## Physical background

In a chiral gauge theory, quantum loops of fermions can break gauge invariance
unless the fermion content satisfies certain algebraic constraints — the anomaly
cancellation conditions. For the Standard Model these are six conditions:

1. **Gravitational–U(1)**: a mixed anomaly between gravity and hypercharge.
2. **U(1)³**: a pure hypercharge cubic anomaly.
3. **SU(2)²–U(1)**: a mixed anomaly between the weak group and hypercharge.
4. **SU(3)²–U(1)**: a mixed anomaly between colour and hypercharge.
5. **SU(3)³**: a pure colour cubic anomaly.
6. **Witten SU(2)**: a global (non-perturbative) anomaly of the weak group.

The fact that the Standard Model fermion content satisfies all six conditions
simultaneously is a highly non-trivial algebraic miracle. Here it is checked
by exact rational arithmetic.

## Representation conventions

All fermions are entered as **left-handed Weyl spinors**. Physical right-handed
fermions (like `u_R`, `d_R`, `e_R`) are entered as their **left-handed
charge-conjugate** fields (`u_R^c`, `d_R^c`, `e_R^c`). Charge conjugation
flips the sign of hypercharge.

Hypercharge is normalised using the project convention
  `Q = T₃ + Y / 2`
which matches Weinberg (1967) and Peskin–Schroeder. Under this convention
the Standard Model multiplets for one generation are:

| Multiplet | SU(3)_c  | SU(2)_L | Y      | Q (upper, lower) |
|-----------|----------|---------|--------|-------------------|
| Q_L       | 3        | 2       | 1/3    | 2/3, −1/3         |
| L_L       | 1        | 2       | −1     | 0, −1             |
| u_R^c     | 3̄        | 1       | −4/3   | −2/3              |
| d_R^c     | 3̄        | 1       | 2/3    | 1/3               |
| e_R^c     | 1        | 1       | 2      | 1                 |

Note: `u_R^c` has `Y = −4/3` because physical `u_R` has `Y = 4/3`, and
charge conjugation negates hypercharge.

## Main results

- `standardModelOneGeneration_localAnomalyFree`: all five perturbative
  anomaly coefficients vanish by exact rational arithmetic.
- `standardModelOneGeneration_wittenAnomalyFree`: the number of doublets
  (with colour multiplicity) is even.
- `standardModelOneGeneration_anomalyFree`: bundled version.
- `nCopies_localAnomalyFree`: anomaly freedom scales to `n` identical
  generation copies (using linearity of the anomaly coefficients).
- `threeGenerations_anomalyFree`: the physical three-generation result.

## Sources

- S. Weinberg, "The Quantum Theory of Fields", Vol. 2, Ch. 22.
- M. Peskin and D. Schroeder, "An Introduction to Quantum Field Theory", Ch. 20.
- R. Delbourgo and A. Salam, Phys. Lett. B 40 (1972) 381. (Grav–U(1))
- E. Witten, Phys. Lett. B 117 (1982) 324. (Global SU(2) anomaly)

## Convention

Trusted module: no `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, or `u n s a f e`.
Provenance: clean-room formalization from standard textbook conditions;
verified by Aristotle proof agent, job 8778de36-1c9d-4266-bc0f-b61055bddd07.
-/

namespace PhysicsSM.StandardModel.AnomalyPackage

/-! ## Colour representation data

We need three cases: colour singlets (leptons, right-handed fields),
colour triplets (left-handed quark doublets), and colour antitriplets
(charge-conjugate right-handed quarks). The anomaly package only requires
the dimension (multiplicity), a flag for coloured states, and a cubic
sign for the SU(3)³ anomaly.
-/

/--
The three colour-representation cases that appear in one Standard Model
generation.

- `singlet`: no colour charge; dimension 1. (Leptons, e_R^c.)
- `triplet`: fundamental colour; dimension 3. (Q_L.)
- `antiTriplet`: antifundamental colour; dimension 3, opposite cubic sign.
  (u_R^c, d_R^c — the charge conjugates of the right-handed quarks.)

The SU(3)³ anomaly receives opposite-sign contributions from triplets and
antitriplets, which is why the quark sector cancels internally.
-/
inductive ColorRep where
  | singlet
  | triplet
  | antiTriplet
deriving DecidableEq, Repr

namespace ColorRep

/--
The number of colour states in each representation.

Singlets contribute once; triplets and antitriplets each contribute with
multiplicity 3. This multiplicity appears in all anomaly sums that involve
coloured states.
-/
def multiplicity : ColorRep → Nat
  | singlet    => 1
  | triplet    => 3
  | antiTriplet => 3

/--
Whether this representation contributes to the mixed `SU(3)²–U(1)` anomaly.

The SU(3)²–U(1) anomaly sum runs only over fields that carry colour charge,
since colourless fields do not couple to the SU(3) gauge boson loop.
-/
def isColored : ColorRep → Bool
  | singlet    => false
  | triplet    => true
  | antiTriplet => true

/--
Relative cubic `SU(3)³` anomaly index.

The fundamental triplet (3) and antifundamental antitriplet (3̄) carry
opposite signs in the pure-SU(3) cubic anomaly because the cubic Casimir
changes sign under complex conjugation of the representation. Singlets
do not couple to SU(3) at all.

Convention: triplet → +1, antitriplet → −1. The overall normalisation
is irrelevant for cancellation; only relative signs matter.
-/
def cubicIndex : ColorRep → Int
  | singlet    => 0
  | triplet    => 1
  | antiTriplet => -1

end ColorRep

/-! ## Weak representation data

The Standard Model uses SU(2)_L doublets and singlets. Only doublets
contribute to the SU(2)²–U(1) and Witten anomaly conditions.
-/

/--
The weak SU(2)_L representation: either a singlet (dimension 1) or a
doublet (dimension 2).

Left-handed quarks Q_L and leptons L_L are doublets. All right-handed
fermions (as charge-conjugate left-handed fields) are singlets under
SU(2)_L because the physical right-handed fields are SU(2)_L singlets.
-/
inductive WeakRep where
  | singlet
  | doublet
deriving DecidableEq, Repr

namespace WeakRep

/-- Dimension of the weak SU(2) representation. -/
def multiplicity : WeakRep → Nat
  | singlet => 1
  | doublet => 2

/--
Whether this representation is an SU(2)_L doublet.

The SU(2)²–U(1) anomaly sum runs only over doublets. Witten's global
SU(2) anomaly is also sensitive only to the total doublet count.
-/
def isDoublet : WeakRep → Bool
  | singlet => false
  | doublet => true

end WeakRep

/-! ## Chiral multiplet record

Each multiplet in the anomaly sum is characterised by three numbers:
its colour representation, its weak representation, and its hypercharge.
The three representation-theory labels determine all six anomaly
coefficients.
-/

/--
A record representing one left-handed chiral multiplet in the anomaly sum.

**Convention**: all physical right-handed fermions must be entered as
their left-handed charge conjugate. The hypercharge of the charge-conjugate
field is the negative of the physical right-handed hypercharge.

For example, the right-handed up quark `u_R` has hypercharge `Y = 4/3`
under `Q = T₃ + Y/2`. Its charge conjugate `u_R^c` is left-handed and
has `Y = −4/3`. It is a colour antitriplet (the bar of 3) and an SU(2)_L
singlet.

The `label` field is for human readability only and does not affect
any computations.
-/
structure ChiralMultiplet where
  label        : String
  color        : ColorRep
  weak         : WeakRep
  hypercharge  : Rat
deriving Repr

namespace ChiralMultiplet

/--
The number of colour states in this multiplet.
This is the dimension of the colour representation: 1 for singlets, 3 for
triplets and antitriplets.
-/
def colorMultiplicity (m : ChiralMultiplet) : Nat :=
  m.color.multiplicity

/--
The number of weak SU(2) states in this multiplet.
This is 1 for singlets, 2 for doublets.
-/
def weakMultiplicity (m : ChiralMultiplet) : Nat :=
  m.weak.multiplicity

/--
The total number of left-handed Weyl fermion states represented by this
multiplet, counting both colour and weak multiplicity.

For example, the quark doublet Q_L is a colour triplet and SU(2) doublet,
so it contributes 3 × 2 = 6 Weyl states per generation.
-/
def totalMultiplicity (m : ChiralMultiplet) : Nat :=
  m.colorMultiplicity * m.weakMultiplicity

end ChiralMultiplet

/-! ## Anomaly coefficients

Each coefficient is a sum over all multiplets, weighted by representation
multiplicities and hypercharge. All five perturbative coefficients must
vanish simultaneously for a consistent gauge theory.

**Note on normalisation**: the Dynkin indices of the SU(2) and SU(3)
representations enter as common factors in the SU(2)²–U(1), SU(3)²–U(1),
and SU(3)³ anomalies. We omit these common normalisations since they do
not affect the vanishing of the anomaly.
-/

/--
The gravitational–`U(1)_Y` mixed anomaly coefficient.

This anomaly arises from a triangle diagram with two graviton vertices and
one hypercharge vertex. The coefficient is the trace of the hypercharge
over all left-handed Weyl fermions:

  `A_grav = ∑_i (color_dim_i × weak_dim_i × Y_i)`

Source: Delbourgo–Salam (1972), Eguchi–Freund (1976).
-/
def gravitationalU1Anomaly (multiplets : List ChiralMultiplet) : Rat :=
  (multiplets.map fun m =>
    ((m.totalMultiplicity : Nat) : Rat) * m.hypercharge).sum

/--
The cubic `U(1)_Y³` anomaly coefficient.

This arises from a triangle diagram with three hypercharge vertices. The
coefficient is the trace of the cube of the hypercharge:

  `A_{Y³} = ∑_i (color_dim_i × weak_dim_i × Y_i³)`

This is one of the tightest constraints on new physics beyond the SM —
any new chiral generation must also satisfy this condition.
-/
def u1CubedAnomaly (multiplets : List ChiralMultiplet) : Rat :=
  (multiplets.map fun m =>
    ((m.totalMultiplicity : Nat) : Rat) * m.hypercharge ^ 3).sum

/--
The mixed `SU(2)_L²–U(1)_Y` anomaly coefficient.

This arises from a triangle with two SU(2)_L gauge bosons and one
hypercharge vertex. Only SU(2)_L doublets contribute; the common doublet
Dynkin index is omitted as a nonzero overall factor.

  `A_{SU(2)²Y} = ∑_{doublets i} (color_dim_i × Y_i)`
-/
def su2SquaredU1Anomaly (multiplets : List ChiralMultiplet) : Rat :=
  (multiplets.map fun m =>
    if m.weak.isDoublet then
      ((m.colorMultiplicity : Nat) : Rat) * m.hypercharge
    else 0).sum

/--
The mixed `SU(3)_c²–U(1)_Y` anomaly coefficient.

This arises from a triangle with two SU(3)_c gluons and one hypercharge
vertex. Only coloured fields contribute. Triplets and antitriplets
contribute with the **same sign** because they have the same quadratic
Dynkin index (the cubic index flips, but not the quadratic one).

  `A_{SU(3)²Y} = ∑_{colored i} (weak_dim_i × Y_i)`
-/
def su3SquaredU1Anomaly (multiplets : List ChiralMultiplet) : Rat :=
  (multiplets.map fun m =>
    if m.color.isColored then
      ((m.weakMultiplicity : Nat) : Rat) * m.hypercharge
    else 0).sum

/--
The pure `SU(3)_c³` anomaly coefficient.

This arises from a triangle with three SU(3)_c gluon vertices. Colour
triplets and antitriplets contribute with **opposite signs** because the
cubic Casimir changes sign under complex conjugation of the representation.
Colourless fields do not contribute.

  `A_{SU(3)³} = ∑_i (weak_dim_i × cubicIndex_i)`

For the Standard Model, Q_L contributes +2 (doublet, triplet) and
u_R^c, d_R^c contribute −1 each (singlets, antitriplet). Total:
2 + (−1) + (−1) = 0. ✓
-/
def su3CubedAnomaly (multiplets : List ChiralMultiplet) : Int :=
  (multiplets.map fun m =>
    (m.weakMultiplicity : Int) * m.color.cubicIndex).sum

/--
Total number of SU(2)_L doublets, counting colour multiplicity.

Witten's global SU(2) anomaly requires that this count be **even**,
because an odd number of doublets would make the path integral vanish
(the Pfaffian of the Dirac operator changes sign under a large SU(2)
gauge transformation).

For one generation: Q_L contributes 3 (colour triplet doublet) and L_L
contributes 1 (singlet doublet). Total: 3 + 1 = 4. Even ✓.
-/
def weakDoubletCount (multiplets : List ChiralMultiplet) : Nat :=
  (multiplets.map fun m =>
    if m.weak.isDoublet then m.colorMultiplicity else 0).sum

/-! ## Anomaly-freedom predicates -/

/--
All five local (perturbative) anomaly cancellation conditions bundled into
a single structure.

A chiral gauge theory is perturbatively anomaly-free if and only if all
five of these conditions hold simultaneously. Failure of any one of them
would make the gauge theory inconsistent at the quantum level.
-/
structure LocalAnomalyFree (multiplets : List ChiralMultiplet) : Prop where
  /-- Mixed gravitational–U(1) anomaly vanishes. -/
  gravitational_u1 : gravitationalU1Anomaly multiplets = 0
  /-- Pure cubic U(1)³ anomaly vanishes. -/
  u1_cubed         : u1CubedAnomaly multiplets = 0
  /-- Mixed SU(2)²–U(1) anomaly vanishes. -/
  su2_squared_u1   : su2SquaredU1Anomaly multiplets = 0
  /-- Mixed SU(3)²–U(1) anomaly vanishes. -/
  su3_squared_u1   : su3SquaredU1Anomaly multiplets = 0
  /-- Pure cubic SU(3)³ anomaly vanishes. -/
  su3_cubed        : su3CubedAnomaly multiplets = 0

/--
Witten's global SU(2) anomaly cancellation condition.

This is a non-perturbative (topological) constraint discovered by Witten
(1982). It requires that the total number of SU(2)_L doublets — summed with
colour multiplicity — be **even**. The Standard Model has 4 per generation
(Q_L × 3 colours + L_L × 1), giving 4 doublets. ✓

Reference: E. Witten, Phys. Lett. B 117 (1982) 324–328.
-/
def WittenSU2AnomalyFree (multiplets : List ChiralMultiplet) : Prop :=
  Even (weakDoubletCount multiplets)

/-! ## One-generation Standard Model fermion table

The Standard Model fermion content for one generation, written entirely
as left-handed Weyl spinors. Right-handed physical fermions are entered
as left-handed charge conjugates (which flips the sign of Y).

Hypercharge assignment: `Q = T₃ + Y/2` (Weinberg convention).

Verification:
- Q_L = (u_L, d_L): Y = 1/3 → Q_u = 1/2 + 1/6 = 2/3 ✓, Q_d = −1/2 + 1/6 = −1/3 ✓
- L_L = (ν_L, e_L): Y = −1  → Q_ν = 1/2 − 1/2 = 0 ✓, Q_e = −1/2 − 1/2 = −1 ✓
- u_R^c: physical u_R has Y = 4/3, so u_R^c has Y = −4/3 → Q = 0 + (−4/3)/2 ... wait,
  u_R^c is a singlet so T₃ = 0, Q = Y/2 = −2/3, matching the antiparticle of u.
- d_R^c: physical d_R has Y = −2/3, so d_R^c has Y = 2/3 → Q = Y/2 = 1/3.
- e_R^c: physical e_R has Y = −2, so e_R^c has Y = 2 → Q = Y/2 = 1.
-/
def standardModelOneGeneration : List ChiralMultiplet :=
  [ { label := "Q_L",   color := ColorRep.triplet,
      weak := WeakRep.doublet, hypercharge := 1 / 3 },
    { label := "L_L",   color := ColorRep.singlet,
      weak := WeakRep.doublet, hypercharge := -1 },
    { label := "u_R^c", color := ColorRep.antiTriplet,
      weak := WeakRep.singlet, hypercharge := -4 / 3 },
    { label := "d_R^c", color := ColorRep.antiTriplet,
      weak := WeakRep.singlet, hypercharge := 2 / 3 },
    { label := "e_R^c", color := ColorRep.singlet,
      weak := WeakRep.singlet, hypercharge := 2 } ]

/-! ## Anomaly cancellation proofs

The proofs proceed by unfolding definitions and then calling `norm_num` to
verify the resulting rational arithmetic. Each proof is a straightforward
computation: enumerate the multiplets, multiply their contributions, and
check that the total is zero.

The verification that these sums vanish is not obvious from the representation
theory alone — it is a deep constraint that selects the Standard Model gauge
group and fermion content.
-/

/--
The conventional one-generation Standard Model table is locally anomaly free.

All five perturbative anomaly coefficients vanish by exact rational arithmetic.
This is verified by the Lean kernel, which evaluates the rational number
computations exactly with no floating-point approximation.

The cancellation works generation-by-generation: each generation is
independently anomaly free. This is why replicating the table three times
(for three generations) also gives an anomaly-free theory.
-/
theorem standardModelOneGeneration_localAnomalyFree :
    LocalAnomalyFree standardModelOneGeneration where
  -- Gravitational–U(1): ∑ (N_c × N_w × Y) = 0
  -- = 6·(1/3) + 2·(−1) + 3·(−4/3) + 3·(2/3) + 1·2
  -- = 2 − 2 − 4 + 2 + 2 = 0 ✓
  gravitational_u1 := by
    simp only [gravitationalU1Anomaly, standardModelOneGeneration,
      ChiralMultiplet.totalMultiplicity, ChiralMultiplet.colorMultiplicity,
      ChiralMultiplet.weakMultiplicity, ColorRep.multiplicity,
      WeakRep.multiplicity, List.map_cons, List.map_nil,
      List.sum_cons, List.sum_nil]
    norm_num
  -- Cubic U(1)³: ∑ (N_c × N_w × Y³) = 0
  -- = 6·(1/3)³ + 2·(−1)³ + 3·(−4/3)³ + 3·(2/3)³ + 1·2³
  -- = 6/27 − 2 − 192/27 + 24/27 + 8
  -- = (6 − 192 + 24)/27 + (−2 + 8) = −162/27 + 6 = −6 + 6 = 0 ✓
  u1_cubed := by
    simp only [u1CubedAnomaly, standardModelOneGeneration,
      ChiralMultiplet.totalMultiplicity, ChiralMultiplet.colorMultiplicity,
      ChiralMultiplet.weakMultiplicity, ColorRep.multiplicity,
      WeakRep.multiplicity, List.map_cons, List.map_nil,
      List.sum_cons, List.sum_nil]
    norm_num
  -- SU(2)²–U(1): ∑_{doublets} (N_c × Y) = 0
  -- Q_L: 3 × (1/3) = 1; L_L: 1 × (−1) = −1. Total: 0 ✓
  su2_squared_u1 := by
    simp only [su2SquaredU1Anomaly, standardModelOneGeneration,
      ChiralMultiplet.colorMultiplicity, ColorRep.multiplicity,
      WeakRep.isDoublet, List.map_cons, List.map_nil,
      List.sum_cons, List.sum_nil]
    norm_num
  -- SU(3)²–U(1): ∑_{colored} (N_w × Y) = 0
  -- Q_L: 2×(1/3); u_R^c: 1×(−4/3); d_R^c: 1×(2/3). Total: 2/3 − 4/3 + 2/3 = 0 ✓
  su3_squared_u1 := by
    simp only [su3SquaredU1Anomaly, standardModelOneGeneration,
      ChiralMultiplet.weakMultiplicity, WeakRep.multiplicity,
      ColorRep.isColored, List.map_cons, List.map_nil,
      List.sum_cons, List.sum_nil]
    norm_num
  -- SU(3)³: ∑ (N_w × cubicIndex) = 0
  -- Q_L: 2×(+1) = +2; u_R^c: 1×(−1) = −1; d_R^c: 1×(−1) = −1. Total: 0 ✓
  su3_cubed := by
    simp only [su3CubedAnomaly, standardModelOneGeneration,
      ChiralMultiplet.weakMultiplicity, WeakRep.multiplicity,
      ColorRep.cubicIndex, List.map_cons, List.map_nil,
      List.sum_cons, List.sum_nil]
    norm_num

/--
The conventional one-generation table has no Witten SU(2) anomaly.

There are 4 doublets per generation (Q_L contributes 3 coloured doublets,
L_L contributes 1). Since 4 = 2 × 2 is even, Witten's condition is satisfied.

Reference: E. Witten, Phys. Lett. B 117 (1982) 324.
-/
theorem standardModelOneGeneration_wittenAnomalyFree :
    WittenSU2AnomalyFree standardModelOneGeneration :=
  ⟨2, rfl⟩

/--
Bundled theorem: the one-generation Standard Model is both locally and
globally anomaly free.

This is the complete anomaly-freedom statement for one generation. The
three-generation result follows from linearity (`threeGenerations_anomalyFree`).
-/
theorem standardModelOneGeneration_anomalyFree :
    LocalAnomalyFree standardModelOneGeneration ∧
      WittenSU2AnomalyFree standardModelOneGeneration :=
  ⟨standardModelOneGeneration_localAnomalyFree,
   standardModelOneGeneration_wittenAnomalyFree⟩

/-! ## Multiple generations

The anomaly coefficients are all linear in the multiplet list: they are
sums over multiplets of per-multiplet contributions. Concatenating `n`
copies of an anomaly-free list therefore gives a list whose anomaly
coefficients are `n` times zero, i.e., still zero.

This linearity is proved via explicit `sum_flatten_replicate` lemmas for
each number type (Rat, Int, Nat). The private helper lemmas below establish
that map commutes with flatten of replicated lists.
-/

/-- `n` identical copies of a multiplet list, obtained by list concatenation. -/
def nCopies (n : Nat) (multiplets : List ChiralMultiplet) :
    List ChiralMultiplet :=
  (List.replicate n multiplets).flatten

/--
Map distributes over flatten of replicated lists.

This is the key structural lemma: applying a function `f` to the flatten
of `n` copies of `xs` gives the same result as flattening `n` copies of
`f` applied to `xs`.
-/
private theorem map_flatten_replicate {α β : Type*} (f : α → β)
    (n : Nat) (xs : List α) :
    ((List.replicate n xs).flatten.map f) =
      (List.replicate n (xs.map f)).flatten := by
  induction n with
  | zero => simp
  | succ n ih =>
    simp [List.replicate_succ, List.flatten_cons,
      List.map_append, ih]

/--
Sum of a flattened replicated `Rat` list equals `n` times the single-copy sum.

This is the linearity fact for rational anomaly coefficients: replicating
a multiplet list `n` times multiplies each rational anomaly coefficient by `n`.
-/
private theorem Rat.sum_flatten_replicate (n : Nat) (xs : List Rat) :
    ((List.replicate n xs).flatten).sum = n * xs.sum := by
  induction n with
  | zero => simp
  | succ n ih =>
    simp [List.replicate_succ, List.flatten_cons,
      List.sum_append, ih]; ring

/--
Sum of a flattened replicated `Int` list equals `n` times the single-copy sum.

Used for the SU(3)³ anomaly, whose coefficient is an integer.
-/
private theorem Int.sum_flatten_replicate (n : Nat) (xs : List Int) :
    ((List.replicate n xs).flatten).sum = n * xs.sum := by
  induction n with
  | zero => simp
  | succ n ih =>
    simp [List.replicate_succ, List.flatten_cons,
      List.sum_append, ih]; ring

/--
Sum of a flattened replicated `Nat` list equals `n` times the single-copy sum.

Used for the Witten doublet count, whose coefficient is a natural number.
-/
private theorem Nat.sum_flatten_replicate (n : Nat) (xs : List Nat) :
    ((List.replicate n xs).flatten).sum = n * xs.sum := by
  induction n with
  | zero => simp
  | succ n ih =>
    simp [List.replicate_succ, List.flatten_cons,
      List.sum_append, ih]; ring

-- Individual scaling lemmas for each anomaly coefficient.
-- Each states that replicating the multiplet list by a factor of `n`
-- scales the corresponding anomaly coefficient by `n`.

/-- Gravitational–U(1) anomaly scales linearly with the number of copies. -/
theorem gravitationalU1Anomaly_nCopies_scaling (n : Nat)
    (ms : List ChiralMultiplet) :
    gravitationalU1Anomaly (nCopies n ms) =
      n * gravitationalU1Anomaly ms := by
  simp only [gravitationalU1Anomaly, nCopies,
    map_flatten_replicate, Rat.sum_flatten_replicate]

/-- Cubic U(1)³ anomaly scales linearly with the number of copies. -/
theorem u1CubedAnomaly_nCopies_scaling (n : Nat)
    (ms : List ChiralMultiplet) :
    u1CubedAnomaly (nCopies n ms) = n * u1CubedAnomaly ms := by
  simp only [u1CubedAnomaly, nCopies,
    map_flatten_replicate, Rat.sum_flatten_replicate]

/-- SU(2)²–U(1) anomaly scales linearly with the number of copies. -/
theorem su2SquaredU1Anomaly_nCopies_scaling (n : Nat)
    (ms : List ChiralMultiplet) :
    su2SquaredU1Anomaly (nCopies n ms) =
      n * su2SquaredU1Anomaly ms := by
  simp only [su2SquaredU1Anomaly, nCopies,
    map_flatten_replicate, Rat.sum_flatten_replicate]

/-- SU(3)²–U(1) anomaly scales linearly with the number of copies. -/
theorem su3SquaredU1Anomaly_nCopies_scaling (n : Nat)
    (ms : List ChiralMultiplet) :
    su3SquaredU1Anomaly (nCopies n ms) =
      n * su3SquaredU1Anomaly ms := by
  simp only [su3SquaredU1Anomaly, nCopies,
    map_flatten_replicate, Rat.sum_flatten_replicate]

/-- SU(3)³ anomaly scales linearly with the number of copies. -/
theorem su3CubedAnomaly_nCopies_scaling (n : Nat)
    (ms : List ChiralMultiplet) :
    su3CubedAnomaly (nCopies n ms) =
      n * su3CubedAnomaly ms := by
  simp only [su3CubedAnomaly, nCopies,
    map_flatten_replicate, Int.sum_flatten_replicate]

/-- Weak doublet count scales linearly with the number of copies. -/
theorem weakDoubletCount_nCopies (n : Nat)
    (ms : List ChiralMultiplet) :
    weakDoubletCount (nCopies n ms) = n * weakDoubletCount ms := by
  simp only [weakDoubletCount, nCopies,
    map_flatten_replicate, Nat.sum_flatten_replicate]

-- Corollaries: if the single-copy anomaly coefficient is zero, then
-- the n-copy anomaly coefficient is also zero.
-- These follow immediately from the scaling lemmas and `mul_zero`.

theorem gravitationalU1Anomaly_nCopies (n : Nat)
    (ms : List ChiralMultiplet)
    (h : gravitationalU1Anomaly ms = 0) :
    gravitationalU1Anomaly (nCopies n ms) = 0 := by
  rw [gravitationalU1Anomaly_nCopies_scaling, h, mul_zero]

theorem u1CubedAnomaly_nCopies (n : Nat)
    (ms : List ChiralMultiplet)
    (h : u1CubedAnomaly ms = 0) :
    u1CubedAnomaly (nCopies n ms) = 0 := by
  rw [u1CubedAnomaly_nCopies_scaling, h, mul_zero]

theorem su2SquaredU1Anomaly_nCopies (n : Nat)
    (ms : List ChiralMultiplet)
    (h : su2SquaredU1Anomaly ms = 0) :
    su2SquaredU1Anomaly (nCopies n ms) = 0 := by
  rw [su2SquaredU1Anomaly_nCopies_scaling, h, mul_zero]

theorem su3SquaredU1Anomaly_nCopies (n : Nat)
    (ms : List ChiralMultiplet)
    (h : su3SquaredU1Anomaly ms = 0) :
    su3SquaredU1Anomaly (nCopies n ms) = 0 := by
  rw [su3SquaredU1Anomaly_nCopies_scaling, h, mul_zero]

theorem su3CubedAnomaly_nCopies (n : Nat)
    (ms : List ChiralMultiplet)
    (h : su3CubedAnomaly ms = 0) :
    su3CubedAnomaly (nCopies n ms) = 0 := by
  rw [su3CubedAnomaly_nCopies_scaling, h, mul_zero]

/--
`n` copies of a locally anomaly-free multiplet list are locally anomaly free.

This follows immediately from linearity: each anomaly coefficient scales by
`n`, and `n × 0 = 0`.
-/
theorem nCopies_localAnomalyFree (n : Nat)
    (ms : List ChiralMultiplet)
    (h : LocalAnomalyFree ms) :
    LocalAnomalyFree (nCopies n ms) :=
  ⟨gravitationalU1Anomaly_nCopies n ms h.gravitational_u1,
   u1CubedAnomaly_nCopies n ms h.u1_cubed,
   su2SquaredU1Anomaly_nCopies n ms h.su2_squared_u1,
   su3SquaredU1Anomaly_nCopies n ms h.su3_squared_u1,
   su3CubedAnomaly_nCopies n ms h.su3_cubed⟩

/--
Three generations of Standard Model fermions are anomaly free.

The physical Standard Model has three generations of fermions. Each
generation is an independent copy of `standardModelOneGeneration`, and
since one generation is anomaly free, three generations are also
anomaly free.

For the Witten condition: each generation has 4 doublets, so three
generations have 12 = 2 × 6 doublets. Even ✓.

This is a kernel-checked confirmation of a cornerstone property of the
Standard Model. No floating-point approximation is used; the computation
is carried out exactly in ℚ.
-/
theorem threeGenerations_anomalyFree :
    LocalAnomalyFree (nCopies 3 standardModelOneGeneration) ∧
      WittenSU2AnomalyFree
        (nCopies 3 standardModelOneGeneration) := by
  refine ⟨nCopies_localAnomalyFree 3 _
    standardModelOneGeneration_localAnomalyFree, ?_⟩
  unfold WittenSU2AnomalyFree
  rw [weakDoubletCount_nCopies]
  -- 3 × 4 = 12 = 2 × 6. Even ✓.
  exact ⟨6, rfl⟩

end PhysicsSM.StandardModel.AnomalyPackage
