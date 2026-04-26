/-!
# StandardModel.Fermions

Fermion representation data.

One generation of Standard Model fermions consists of the following Weyl spinors:

Left-handed doublets:
  Q_L = (u_L, d_L) : (3, 2, +1/3)   quark doublet
  L_L = (ν_L, e_L) : (1, 2, -1)     lepton doublet

Right-handed singlets:
  u_R : (3, 1, +4/3)   up-type quark
  d_R : (3, 1, -2/3)   down-type quark
  e_R : (1, 1, -2)     charged lepton

Numbers in (SU(3) rep, SU(2) rep, Y) with Q = T₃ + Y/2.

This gives 15 Weyl spinor degrees of freedom per generation (16 with ν_R).

Convention: hypercharge follows Q = T₃ + Y/2.

Source: Peskin and Schroeder, §20.2.

Status: stub — fermion record types and representation labels to be defined.
-/

namespace PhysicsSM.StandardModel.Fermions

end PhysicsSM.StandardModel.Fermions
