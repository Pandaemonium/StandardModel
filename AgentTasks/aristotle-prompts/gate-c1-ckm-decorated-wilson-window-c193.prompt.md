Project name: gate-c1-ckm-decorated-wilson-window-c193

You are Aristotle, working on the Null-edge / NullStrand Gate C1 program.

Current status:
C173 proved the CKM table: M_CKM(level 0)=15 and M_CKM(level>0)=-1.
C174 proved the shifted CKM window in the diagnostic R=I case: W_CKM=0 at level 0, W_CKM=16r_b at level>0, and 0<m0<16r_b gives one CKM-light sector.
C175 proved pure product parity is an 8+8 no-go.
C179 and Pro guidance say the first physical operator should be Wilson/Neuberger overlap with CKM as finite branch/flavor texture, not literal naive CKM as the spacetime doubler-resolution operator.

Task:
Formalize the combined free mass-window theorem for the CKM-decorated Wilson/Neuberger reference.

Model:
A sector is labeled by:
  n   = number of spacetime pi-components, with n=0 physical and n>=1 Wilson spacetime doubler;
  ell = CKM level, with ell=0 CKM-light and ell>0 CKM-heavy.

Use shifted mass:
  mu(n, ell) = 2*r_W*n + w(ell) - m0
where:
  w(0) = 0
  w(ell>0) = 16*r_b.

Target theorem:
Assume r_W>0, r_b>0, and
  0 < m0 < min(2*r_W, 16*r_b).
Then:
1. mu(0,0) < 0.
2. If n>=1 and ell=0, then mu(n,0) > 0.
3. If ell>0, then mu(n,ell) > 0 for every n>=0.
4. Therefore exactly one sector, (n=0, ell=0), is negative/light, while all spacetime doublers and CKM-heavy sectors are positive/heavy.
5. Give an explicit free margin:
   gamma_free = min(m0, 2*r_W - m0, 16*r_b - m0)
   or an equivalent lower bound by this quantity.

Requested output:
- Lean-ready theorem statements, preferably over Nat sector labels and Real parameters;
- proof or proof sketch of the positivity/sign split;
- multiplicity/counting optional but helpful if n ranges over d=4 spacetime corners and ell over 16 CKM corners;
- note on how this theorem feeds the sector-signature match and C170/C181 reference-gap budget.

Do not claim full GateC1_NU. This is the combined free mass-window/sign-straddling certificate for the Wilson+CKM reference.
