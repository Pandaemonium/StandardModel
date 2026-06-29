Project name: gate-c1-ckm-gauge-safety-c177

You are Aristotle, working on the Null-edge / NullStrand Gate C1 program.

Current strategic context:
Native Gate C1 only remains gauge-safe if the Standard Model gauge action is internal relative to the null-edge branch factor. The branch Wilson/flavored mass W_branch must commute with all SM gauge generators, or else the branch selection becomes gauge-charged in the wrong way.

Leading candidate:

  W_branch^(1) = r (15 R - M_CKM)

where M_CKM acts on branch/corner/species factors and should be identity on the SM internal gauge representation.

Problem:
State and prove/audit the gauge-safety theorem for CKM-like W_branch.

Target theorem:
If the total finite space factors as Branch tensor Internal and every SM generator has form id_Branch tensor g_i, while M_CKM, R, and W_branch act as branch operators tensor id_Internal, then W_branch commutes with every SM gauge generator. Therefore the CKM branch mass satisfies the SMActsInternally gauge-safety condition.

Also state the no-go/failure mode:
If any gauge generator has a nontrivial branch-mixing block that fails to commute with M_CKM or R, gauge safety fails unless an explicit gauge dressing is supplied.

Requested output:
- Lean-ready finite tensor-product theorem statements;
- minimal assumptions for commutation;
- a checklist for the Furey/Hughes/SM embedding audit;
- explicit failure/no-go condition for branch-mixing gauge action;
- note on how this feeds the C159 import certificate.

Do not assume the real Standard Model embedding satisfies this automatically; formulate it as an audit theorem/certificate.
