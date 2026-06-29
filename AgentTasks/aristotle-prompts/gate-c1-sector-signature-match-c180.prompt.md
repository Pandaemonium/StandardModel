Project name: gate-c1-sector-signature-match-c180

You are Aristotle, working on the Null-edge / NullStrand Gate C1 program.

Current status:
C178 defined the sector-signature checklist for matching a null-edge kernel to a reference kernel:
  rank, chirality, branch parity, gauge representation, shifted mass sign, Krein sign, anomaly/index weight.
C154/C172 show sector signatures plus gap bounds form a GO/NO-GO test for straight-line gapped homotopy.

Task:
Build a Lean-ready finite/API theorem package for SectorSignatureMatch.

Requested results:
1. Define a 7-slot `SectorSignature` record.
2. Define `SignatureMatch` sector-by-sector and for finite sector families.
3. Prove that one-slot mismatch gives a failed match.
4. Prove that same bad-sector shifted mass signs plus inverse-gap bounds prevent zero crossing on bad sectors under straight-line homotopy.
5. Give an API theorem connecting `SignatureMatch` plus C170 sub-gap bound to the C159 reference-import precondition.
6. Include the one-light-sector uniqueness condition separately from the bad-sector match.

Requested output:
- Lean-ready theorem statements and, if possible, a small standalone Mathlib formalization;
- precise failure/no-go theorem for a single mismatched slot;
- notes on how to instantiate the signature for CKM texture vs doubler-resolved reference.

Do not hide physical claims inside equality of signatures: anomaly/index, locality/control, determinant-line, and SM internality should remain external certificates.
