# Offline calculation oracles

These are synthetic/reconstructed fixtures, not runtime logs or certification.

## Weighted errors

Input: A 400 requests/min at 1%, B 350 at 4%, C 250 at 8%.
Expected: total 1000 requests/min; failures A=4, B=14, C=20; total=38/min;
weighted rate=3.8%; C contributes 20/38=52.63% of failures.
Volume alone would incorrectly select A.

Alternate input: A 600/min at 2%, B 300 at 5%, C 100 at 10%.
Expected failures 12,15,10; total 37/min, weighted 3.7%; B contributes most.

## Sequential calls

Input: A 1000/min, each calls B; 30% B call C; service times A/B/C=20/50/100 ms;
sequential synchronous, no queueing.
B arrival=1000/min; C=300/min.
Root latency: 70 ms for 70%, 170 ms for 30%; mean=100 ms.
Unique root in-flight=(1000/60)*0.1=1.6667.
Summed pure service occupancy=(1000/60)*0.02+(1000/60)*0.05+(300/60)*0.1=1.6667.
If handlers remain occupied through downstream waits, held occupancy:
A=1.6667, B=(1000/60)*0.08=1.3333, C=0.5; sum=3.5.
No worker counts/capacity were supplied; bottleneck/headroom cannot be inferred.
