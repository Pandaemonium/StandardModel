/-!
# StandardModel.Fermions

Fermion representation data.

Claim boundary: this module is a conventional Standard Model data stub, not a
theorem saying that any octonionic construction has produced the full fermion
sector. In particular, the Krasnov/Baez `O^2` route currently accounts only for
a one-generation left-handed representation. Physical right-handed fermions and
three generations remain open in that route.

One generation of Standard Model fermions consists of the following Weyl spinors:

Left-handed doublets:
  Q_L = (u_L, d_L) : (3, 2, +1/3)   quark doublet
  L_L = (ν_L, e_L) : (1, 2, -1)     lepton doublet

Physical right-handed singlets:
  u_R : (3, 1, +4/3)   up-type quark
  d_R : (3, 1, -2/3)   down-type quark
  e_R : (1, 1, -2)     charged lepton

Equivalent all-left-handed Weyl convention:
  u_R^c : (3bar, 1, -4/3)
  d_R^c : (3bar, 1, +2/3)
  e_R^c : (1, 1, +2)

Any anomaly bridge must state explicitly which convention it uses.

Numbers in (SU(3) rep, SU(2) rep, Y) with Q = T₃ + Y/2.

This gives 15 Weyl spinor degrees of freedom per generation (16 with ν_R).

Convention: hypercharge follows Q = T₃ + Y/2.

Source: Peskin and Schroeder, §20.2.

Status: stub — fermion record types and representation labels to be defined.
-/

namespace PhysicsSM.StandardModel.Fermions

end PhysicsSM.StandardModel.Fermions
