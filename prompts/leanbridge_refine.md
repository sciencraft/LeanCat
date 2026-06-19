The previous Lean 4 proof attempt contains errors. Your goal is to fix them according to the compiler's error message.

Input:
Lean 4 code:
{original_proof}

Error messages:
{error_messages}

Instructions:
1. First, analyze the error message carefully in a "## Error Analysis" section.
2. Decide whether you need to search Mathlib for external knowledge or can fix the proof immediately.
3. You may preserve or add auxiliary definitions, instances, and lemmas needed by the final proof, but keep the target statement unchanged. The target statement and all auxiliary code must contain no sorry, admit, axiom, or unsafe declarations.

Condition A: If you need external information
Output the search query wrapped in the tag below:
[SEARCH: your_search_query]

Condition B: If you can fix it immediately
Output the analysis and the fully refined code.
