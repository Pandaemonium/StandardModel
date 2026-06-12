import Mathlib
import PhysicsSM.Algebra.Furey.ElectroweakPaperPackage
import PhysicsSM.Algebra.Furey.T3OpJbar
import PhysicsSM.Algebra.Furey.WeakIsospinDoublets
import PhysicsSM.Algebra.Furey.WeakIsospinLadder

/-!
# Furey electroweak complete citation package

This module bundles the complete Furey electroweak formalization into a
single citeable record for Section 5 of the paper. It combines:

- The Q_op eigenvalue table and operator-level GMN relation
  (`FureyElectroweakPaperPackage`).
- The T₃ operator and its doublet eigenvalues (`T3OpJbarPackage`).
- The four SU(2)_L doublet pairings (`FureySU2LDoubletPackage`).
- The W⁺/W⁻ ladder operators and su(2) commutation relations
  (`FureyWeakIsospinLadderPackage`).

It also proves two derived results:

1. **[Q, W⁺] = W⁺** and **[Q, W⁻] = −W⁻** — the charge operator Q
   satisfies the correct commutation relations with the raising/lowering
   operators, following from `[T₃, W±] = ±W±` and `[Y, W±] = 0` by
   linearity of the commutator.

## Claim boundary

This file bundles Furey's finite-state electroweak formalization. It does
**not** derive the SU(2)_L algebra from the octonionic ladder operators —
the W± operators are defined by explicit permutation maps on the basis states,
not constructed from α_i ladder operators. A future derivation would be a
separate result.

## Status

Trusted module: no `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
-/

namespace PhysicsSM.Algebra.Furey.ElectroweakCompletePackage

open PhysicsSM.Algebra.Furey.ElectroweakBridge
open PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity
open PhysicsSM.Algebra.Furey.T3OpJbar
open PhysicsSM.Algebra.Furey.WeakIsospinDoublets
open PhysicsSM.Algebra.Furey.WeakIsospinLadder
open PhysicsSM.Algebra.Furey.ElectroweakPaperPackage

/-! ## Charge commutation with W± -/

/-- The physical charge operator Q commutes correctly with T⁺:
    [Q, T⁺] = T⁺.  This follows from `[T₃, T⁺] = T⁺` and `[Y, T⁺] = 0`
    by linearity, using the GMN relation `Q = T₃ + Y/2`. -/
theorem Q_comm_TPlus :
    endComm physicalQEnd TPlusEnd = TPlusEnd := by
  ext psi s; simp +decide [ endComm ] ;
  fin_cases s <;> simp +decide [ tPlusSource ];
  · unfold physicalQ; norm_num;
  · unfold physicalQ; norm_num; ring;
  · unfold physicalQ; norm_num; ring;
  · unfold physicalQ; norm_num; ring;

/-- The physical charge operator Q commutes correctly with T⁻:
    [Q, T⁻] = −T⁻.  This follows from `[T₃, T⁻] = −T⁻` and `[Y, T⁻] = 0`
    by linearity, using the GMN relation `Q = T₃ + Y/2`. -/
theorem Q_comm_TMinus :
    endComm physicalQEnd TMinusEnd = -TMinusEnd := by
  ext psi s; simp +decide [ endComm ] ;
  fin_cases s <;> simp +decide [ tMinusSource ];
  · unfold physicalQ; norm_num; ring;
  · erw [ show physicalQ 2 = -1 / 3 by rfl, show physicalQ 5 = 2 / 3 by rfl ] ; ring;
  · erw [ show physicalQ 3 = -1 / 3 by rfl, show physicalQ 6 = 2 / 3 by rfl ] ; ring;
  · unfold physicalQ;
    norm_num [ Fin.ext_iff ]

/-! ## Complete bundle -/

/-- The complete Furey electroweak formalization bundle, collecting all
    kernel-checked results for Section 5 of the paper. -/
structure FureyElectroweakCompletePackage where
  /-- The Q_op eigenvalue table and operator-level GMN relation. -/
  electroweak : FureyElectroweakPaperPackage
  /-- The T₃ operator and its doublet eigenvalues. -/
  t3_operator : T3OpJbarPackage
  /-- The four SU(2)_L doublet pairings. -/
  doublets : FureySU2LDoubletPackage
  /-- The W⁺/W⁻ ladder operators and su(2) commutation relations. -/
  ladder : FureyWeakIsospinLadderPackage
  /-- Q commutes with W⁺: [Q, W⁺] = W⁺. -/
  q_comm_tplus : endComm physicalQEnd TPlusEnd = TPlusEnd
  /-- Q commutes with W⁻: [Q, W⁻] = −W⁻. -/
  q_comm_tminus : endComm physicalQEnd TMinusEnd = -TMinusEnd

/-- The assembled complete Furey electroweak package. -/
noncomputable def fureyElectroweakCompletePackage :
    FureyElectroweakCompletePackage where
  electroweak := fureyElectroweakPaperPackage
  t3_operator := t3OpJbarPackage
  doublets := fureySU2LDoubletPackage
  ladder := fureyWeakIsospinLadderPackage
  q_comm_tplus := Q_comm_TPlus
  q_comm_tminus := Q_comm_TMinus

end PhysicsSM.Algebra.Furey.ElectroweakCompletePackage
