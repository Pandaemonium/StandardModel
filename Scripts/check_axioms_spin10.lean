import PhysicsSM.Spinor.SpinorTenfoldCAR
import PhysicsSM.Spinor.SpinorTenfoldGammaSymm
import PhysicsSM.Spinor.SpinorTenfoldColorAxis
import PhysicsSM.Spinor.SpinorTenfoldFierzKernel
import PhysicsSM.Spinor.SpinorTenfoldFierz

-- Trusted: every theorem below must show only propext / Classical.choice /
-- Quot.sound. In particular no Lean.ofReduceBool / Lean.trustCompiler
-- (`native_decide`).
#print axioms PhysicsSM.Spinor.SpinorTenfold.cliffordAction_cliffordAction_self
#print axioms PhysicsSM.Spinor.SpinorTenfold.gammaBilinear_symm
#print axioms PhysicsSM.Spinor.SpinorTenfold.sum_quadric_iff_single
#print axioms PhysicsSM.Spinor.SpinorTenfold.finrank_colorAxis
#print axioms PhysicsSM.Spinor.SpinorTenfold.Q10_eq_zero_of_mem_annihilator
#print axioms PhysicsSM.Spinor.SpinorTenfold.fierzZ_three
#print axioms PhysicsSM.Spinor.SpinorTenfold.fierz_clifford
#print axioms PhysicsSM.Spinor.SpinorTenfold.sharpMap_graph_eq_zero_of_even
