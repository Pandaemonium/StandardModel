Project name: gate-c1-ckm-mass-table-c173

You are Aristotle, working on the Null-edge / NullStrand Gate C1 program.

Current strategic context:
Gate C1 is being reframed as a reference-kernel import problem. The intended null-edge overlap kernel is

  H_ne    = Gamma_K (D_ne + W_branch - m0 R)
  T_br    = sign(H_ne)
  D_ov_ne = rho (1 + Gamma_K T_br)

The finite branch seed is not itself the physical release. It is input to a known-reference import theorem. The new leading reference is a Creutz-Kimura-Misumi style one-sector naive flavored-overlap mass, not the pure product/parity mass.

Problem:
Formalize or give a precise finite theorem package for the CKM-style 4D corner mass table. Let a Brillouin/branch corner be represented by four signs c_mu in {+1,-1}, with level = number of -1 signs. Let M_P, M_V, M_T, M_A denote the product/parity, vector, tensor, and axial point-split/flavored components in the CKM-style one-flavor mass combination

  M_CKM = M_P + M_V + M_T + M_A.

Target result:
Prove or derive a clean exact table showing

  M_CKM(level 0) = 15,
  M_CKM(level > 0) = -1.

Please do one of the following:
1. Give a Lean-ready finite definition of the signs/components and prove the table.
2. If the formula above is underspecified, identify the exact missing convention and propose the minimal convention needed to make the theorem true.
3. If the statement is false under the standard CKM conventions, give the corrected formula/table.

Requested output:
- precise definitions for M_P, M_V, M_T, M_A on {+1,-1}^4;
- the exact corner table by level;
- Lean-ready theorem statements, preferably standalone over Fin 4 and signs;
- any helper lemmas needed;
- a short note on how this table feeds ShiftedCKM_OneSector_Window.

Do not weaken the one-sector table silently. If conventions matter, say so explicitly.
