# Summary of changes for run cd041e11-d691-47d7-b535-0b08a571fe6c
Delivered the definitions honesty audit as `DEFINITIONS_HONESTY_AUDIT.md`. Per your format, each of (1)-(5) gets a faithful/rigged + content-in-def/proof verdict with the specific breaking alternative; the load-bearing arithmetic (detG=2abc, Frobenius=a²+b²+2x², and the four chiral gap entries) was verified in Lean before I committed to conclusions.

Findings:

(1) Lambda exponent `α/2−1` — FAITHFUL but tautological (content-in-def). The `/2` (sqrt) and `−1` (÷N) are forced once α is the count-VARIANCE exponent; theorem just restates the def. Breaking alt: α as std-dev exponent → `α−1` (less defensible).

(2) budget `a²+b²+2x²` vs detP `ab−x²` — FAITHFUL (content-in-proof). The `2` is the honest Frobenius value (two off-diagonal entries), and crucially the sign-mismatch headline survives ANY positive coefficient, so `2` does not carry it. Real structural fact.

(3) massPair `2(a+b+c)` vs detG `2abc` — massPair FAITHFUL & forced ((Σp)² with null edges = 2Σpᵢ·pⱼ); detG is a semi-straw comparator (a real Gram determinant, but nobody calls it "mass"). Content-in-def; refutes only a conflation nobody need make.

(4) Chiral protection — RIGGED, the smoking gun (content-in-def). Labels (odd/even w.r.t. Γ) check out, and A being nilpotent rank-1 is actually forced (a 2D chiral zero mode requires it). But the gap of v equals |Pv|², which depends only on whether P touches v's chirality slot — NOT on parity. The chosen `Podd=[[0,s],[0,0]]` has q=0 (annihilates v → "protected") and `Peven=diag(m,−m)` has a=m≠0 (→ gap m²). Equally/more defensible alternatives flip BOTH halves: the genuine symmetric Dirac mass `[[0,m],[m,0]]` is odd yet gaps (q²), and the even `diag(0,m)` does not gap. The grading is a decoration; the headline is a definitional artifact.

(5) edge `vvᵀ` + 6-coeff Qform — FAITHFUL, cleanest (content-in-proof). edge = all rank-1 PSD sym 2×2; Qform spans all 6 quadratic monomials; det-uniqueness is a genuine 6→1 fact (irreducible quadric argument).

Top 2 most at risk of question-begging: (4) chiral protection (genuinely rigged — the physics lives entirely in the un-argued choice of Podd/Peven representatives) and (1) lambda exponent (theorem = def, though the def is forced-honest); with (3) as runner-up. (2) and (5) are faithful and safe.

The document is committed and pushed. No Lean proof was required for this strategy/audit task; the repo's Main.lean was untouched.
