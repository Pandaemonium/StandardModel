import PhysicsSM.Draft.NullEdgeDiracSlashCore
import PhysicsSM.Draft.NullEdgeDiracTwoSheetCore

/-!
# Draft.NullEdgeDiracMassShellProjectorsCore

Finite mass-shell branch projectors for the chiral Dirac slash.

This draft module specializes the abstract two-sheet projector algebra from
`NullEdgeDiracTwoSheetCore` to the concrete chiral Dirac slash from
`NullEdgeDiracSlashCore`.  It is finite matrix algebra in the explicit
`(+---)` convention; it is not yet a graph propagation or scattering theorem.

Provenance: integrated from the focused Aristotle job
`null-edge-dirac-mass-shell-projectors-core-20260621`, with definitions routed
through the existing draft Dirac modules rather than duplicated verbatim.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeDiracMassShellProjectorsCore

open Matrix Complex

abbrev ChiralIdx := Sum (Fin 2) (Fin 2)

/-- The concrete chiral Dirac slash squares to the Minkowski scalar. -/
theorem chiralDiracSlash_sq_eq_norm (p : Fin 4 -> Complex) :
    NullEdgeDiracSlashCore.chiralDiracSlash p *
        NullEdgeDiracSlashCore.chiralDiracSlash p =
      NullEdgeDiracSlashCore.minkowskiNorm p •
        (1 : Matrix ChiralIdx ChiralIdx Complex) :=
  NullEdgeDiracSlashCore.chiralDiracSlash_sq_eq_norm p

/-- Mass-shell specialization of the concrete chiral Dirac square. -/
theorem chiralDiracSlash_sq_eq_massSq_of_massShell
    (p : Fin 4 -> Complex) (m : Complex)
    (h : NullEdgeDiracSlashCore.minkowskiNorm p = m * m) :
    NullEdgeDiracSlashCore.chiralDiracSlash p *
        NullEdgeDiracSlashCore.chiralDiracSlash p =
      (m * m) • (1 : Matrix ChiralIdx ChiralIdx Complex) := by
  rw [← h, chiralDiracSlash_sq_eq_norm]

/-- The positive branch projector for the chiral slash is idempotent on shell. -/
theorem chiralPlusProjector_idempotent
    (p : Fin 4 -> Complex) (m : Complex) (hm : m != 0)
    (h : NullEdgeDiracSlashCore.minkowskiNorm p = m * m) :
    NullEdgeDiracTwoSheetCore.plusProjector
        (NullEdgeDiracSlashCore.chiralDiracSlash p) m *
      NullEdgeDiracTwoSheetCore.plusProjector
        (NullEdgeDiracSlashCore.chiralDiracSlash p) m =
        NullEdgeDiracTwoSheetCore.plusProjector
          (NullEdgeDiracSlashCore.chiralDiracSlash p) m :=
  NullEdgeDiracTwoSheetCore.plusProjector_idempotent_of_sq
    (D := NullEdgeDiracSlashCore.chiralDiracSlash p) (m := m) hm
    (chiralDiracSlash_sq_eq_massSq_of_massShell p m h)

/-- The negative branch projector for the chiral slash is idempotent on shell. -/
theorem chiralMinusProjector_idempotent
    (p : Fin 4 -> Complex) (m : Complex) (hm : m != 0)
    (h : NullEdgeDiracSlashCore.minkowskiNorm p = m * m) :
    NullEdgeDiracTwoSheetCore.minusProjector
        (NullEdgeDiracSlashCore.chiralDiracSlash p) m *
      NullEdgeDiracTwoSheetCore.minusProjector
        (NullEdgeDiracSlashCore.chiralDiracSlash p) m =
        NullEdgeDiracTwoSheetCore.minusProjector
          (NullEdgeDiracSlashCore.chiralDiracSlash p) m :=
  NullEdgeDiracTwoSheetCore.minusProjector_idempotent_of_sq
    (D := NullEdgeDiracSlashCore.chiralDiracSlash p) (m := m) hm
    (chiralDiracSlash_sq_eq_massSq_of_massShell p m h)

/-- The chiral plus and minus branch projectors are orthogonal on shell. -/
theorem chiralProjectors_orthogonal
    (p : Fin 4 -> Complex) (m : Complex) (hm : m != 0)
    (h : NullEdgeDiracSlashCore.minkowskiNorm p = m * m) :
    NullEdgeDiracTwoSheetCore.plusProjector
        (NullEdgeDiracSlashCore.chiralDiracSlash p) m *
      NullEdgeDiracTwoSheetCore.minusProjector
        (NullEdgeDiracSlashCore.chiralDiracSlash p) m = 0 :=
  NullEdgeDiracTwoSheetCore.plus_minus_orthogonal_of_sq
    (D := NullEdgeDiracSlashCore.chiralDiracSlash p) (m := m) hm
    (chiralDiracSlash_sq_eq_massSq_of_massShell p m h)

/-- The chiral slash acts with eigenvalue `m` on the positive branch. -/
theorem chiralDirac_acts_on_plusProjector
    (p : Fin 4 -> Complex) (m : Complex) (hm : m != 0)
    (h : NullEdgeDiracSlashCore.minkowskiNorm p = m * m) :
    NullEdgeDiracSlashCore.chiralDiracSlash p *
        NullEdgeDiracTwoSheetCore.plusProjector
          (NullEdgeDiracSlashCore.chiralDiracSlash p) m =
      m •
        NullEdgeDiracTwoSheetCore.plusProjector
          (NullEdgeDiracSlashCore.chiralDiracSlash p) m :=
  NullEdgeDiracTwoSheetCore.dirac_acts_on_plusProjector
    (D := NullEdgeDiracSlashCore.chiralDiracSlash p) (m := m) hm
    (chiralDiracSlash_sq_eq_massSq_of_massShell p m h)

/-- The chiral slash acts with eigenvalue `-m` on the negative branch. -/
theorem chiralDirac_acts_on_minusProjector
    (p : Fin 4 -> Complex) (m : Complex) (hm : m != 0)
    (h : NullEdgeDiracSlashCore.minkowskiNorm p = m * m) :
    NullEdgeDiracSlashCore.chiralDiracSlash p *
        NullEdgeDiracTwoSheetCore.minusProjector
          (NullEdgeDiracSlashCore.chiralDiracSlash p) m =
      (-m) •
        NullEdgeDiracTwoSheetCore.minusProjector
          (NullEdgeDiracSlashCore.chiralDiracSlash p) m :=
  NullEdgeDiracTwoSheetCore.dirac_acts_on_minusProjector
    (D := NullEdgeDiracSlashCore.chiralDiracSlash p) (m := m) hm
    (chiralDiracSlash_sq_eq_massSq_of_massShell p m h)

end PhysicsSM.Draft.NullEdgeDiracMassShellProjectorsCore

end
