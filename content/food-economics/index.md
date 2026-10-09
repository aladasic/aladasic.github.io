---
title: Food Economics
summary: Standard economics applied to food, recent research on the economics of food, and my own work on Michelin-starred restaurants.
date: 2026-10-09
math: true
toc: true
tags:
  - Food economics
  - Microeconomics
  - International economics
---

Food is one of the best ways into economics. Everyone eats, prices are visible, and a menu is a small lesson in demand, competition and exchange rates. This page collects (i) some standard economic tools applied to food, (ii) recent research and articles I find interesting, and (iii) my own early work on the price of Michelin stars.

## Part I. Standard economics, applied to food

### 1. Normal, inferior and superior goods: Engel's law

How does demand for a food respond when income $m$ rises? The **income elasticity of demand** measures it:

$$
\eta_m = \frac{\partial q}{\partial m}\,\frac{m}{q}
$$

- $\eta_m < 0$: **inferior good**. People buy less of it as they get richer (cheap staples, instant noodles).
- $0 < \eta_m < 1$: **necessity**. Demand rises, but less than income. Food as a whole is the classic example.
- $\eta_m > 1$: **superior (luxury) good**. Demand rises faster than income (fine dining, champagne, truffles).

**Engel's law** follows directly. Let $w = pq/m$ be the share of the budget spent on food. Differentiating with respect to income:

$$
\frac{\partial w}{\partial m} = \frac{p}{m}\frac{\partial q}{\partial m} - \frac{pq}{m^2} = \frac{pq}{m^2}\left(\eta_m - 1\right)
$$

So the food budget share falls with income if and only if $\eta_m < 1$. Rich households spend more on food in absolute terms, but a smaller share of their income. The same household can have $\eta_m < 1$ for groceries and $\eta_m > 1$ for restaurants: if its restaurant spending has $\eta_m = 1.5$, a 10% rise in income raises that spending by about 15%, and its share of the budget by about 5%.

At the other extreme, an inferior staple can even become a **Giffen good**, whose demand rises with its own price. Jensen and Miller (2008) found evidence of Giffen behaviour for rice among very poor households in Hunan, China: when rice became dearer, they could no longer afford meat and bought *more* rice to keep their calorie intake.

### 2. Veblen goods: when the price is part of the meal

For a **Veblen good**, a higher price can *raise* demand because the price itself signals status (Veblen, 1899). Leibenstein (1950) formalised this by letting demand depend on the price actually paid, $p$, and on the "conspicuous price" $p_c$, the price others believe you paid:

$$
q = D(p, p_c), \qquad \frac{\partial D}{\partial p} < 0 \;\;\text{(functional effect)}, \qquad \frac{\partial D}{\partial p_c} > 0 \;\;\text{(Veblen effect)}
$$

In equilibrium the conspicuous price is the market price, $p_c = p$, so the total effect of a price change is:

$$
\frac{dq}{dp} = \frac{\partial D}{\partial p} + \frac{\partial D}{\partial p_c}
$$

Demand slopes upward whenever the Veblen effect dominates. With a simple constant-elasticity form, $q = A\,p^{-\varepsilon}\,p_c^{\gamma}$, setting $p_c = p$ gives $q = A\,p^{\gamma - \varepsilon}$, which is increasing in $p$ when $\gamma > \varepsilon$.

Tasting menus, cult wines and "invitation-only" restaurants are natural examples: part of what is consumed is the knowledge that it was expensive. This differs from a Giffen good. The Giffen effect comes from an income effect on a poor household; the Veblen effect comes from preferences over status (see Bagwell and Bernheim, 1996, for a signalling foundation).

### 3. Spatial competition: Hotelling's linear city

Why do restaurants cluster on the same street, and why can a restaurant charge more when its rivals are far away? Hotelling (1929) models a "linear city" $[0,1]$ with a unit mass of consumers spread uniformly along it. Each consumer buys one meal, and travelling a distance $d$ costs $t\,d$.

**(a) Location with fixed prices: minimum differentiation.** Suppose two restaurants charge the same price and choose locations $a \le b$. Each consumer goes to the nearest one, so restaurant 1 serves everyone to the left of the midpoint:

$$
\text{market share}_1 = \frac{a+b}{2}
$$

This increases with $a$, so restaurant 1 moves towards its rival, and vice versa. The only equilibrium is $a = b = \tfrac{1}{2}$: both restaurants end up side by side in the middle of the street. Total travel costs would be lowest at $\tfrac{1}{4}$ and $\tfrac{3}{4}$, so the clustering is privately rational but socially wasteful.

**(b) Price competition with fixed locations.** Now place the restaurants at the two ends of the city, each with marginal cost $c$. The consumer at $\hat{x}$ who is indifferent between the two satisfies:

$$
p_1 + t\,\hat{x} = p_2 + t\,(1-\hat{x}) \quad\Longrightarrow\quad \hat{x} = \frac{1}{2} + \frac{p_2 - p_1}{2t}
$$

Restaurant 1 maximises $\pi_1 = (p_1 - c)\,\hat{x}$. The first-order condition gives the best response:

$$
p_1 = \frac{p_2 + c + t}{2}
$$

and by symmetry the equilibrium is:

$$
p_1^* = p_2^* = c + t, \qquad \pi_1^* = \pi_2^* = \frac{t}{2}
$$

The mark-up equals the travel cost $t$: the more inconvenient it is to reach the rival, the more market power each restaurant has. When firms choose both location and price, d'Aspremont, Gabszewicz and Thisse (1979) show that, with quadratic travel costs, firms move as *far apart* as possible to soften price competition.

{{< callout note >}}
**Not to be confused with the Hotelling *rule*.** In a separate paper, Hotelling (1931) showed that the net price (scarcity rent) of an exhaustible resource should rise at the rate of interest, $p_t = p_0\,e^{rt}$. It is the starting point for thinking about scarce natural resources, from fossil fuels to fish stocks.
{{< /callout >}}

### 4. Purchasing power parity and the Big Mac Index

The **law of one price** says that, without trade costs, an identical good should cost the same everywhere once prices are converted into a common currency: $p = S\,p^*$, where $S$ is the price of one unit of foreign currency in home currency. Applied to a whole basket, this gives **absolute PPP**:

$$
S^{PPP} = \frac{P}{P^*}
$$

and, in growth rates, **relative PPP**: the exchange rate depreciates by the inflation differential, $\Delta S/S \approx \pi - \pi^*$.

*The Economist*'s **Big Mac Index** applies this to a single, highly standardised food product. For country $j$, the burger-implied exchange rate against the US dollar and the implied valuation of the currency are:

$$
S_j^{BM} = \frac{P_j^{BM}}{P_{US}^{BM}}, \qquad V_j = \frac{S_j^{BM}}{S_j} - 1
$$

where $S_j$ is the market exchange rate (local currency per US dollar). If $V_j < 0$, the currency is undervalued: the Big Mac is cheaper in country $j$ than in the US at market exchange rates.

*Illustrative numbers:* if a Big Mac costs EUR 5.00 in the euro area and USD 6.00 in the US, the implied rate is $5/6 \approx 0.83$ euros per dollar. With a market rate of 0.90, $V = 0.83/0.90 - 1 \approx -7\%$: the euro is about 7% undervalued against the dollar in "burger terms".

PPP fails in the short run, and even in the long run for many goods. A Big Mac contains a lot of **non-traded inputs** (rent, wages, local taxes), and these are systematically cheaper in poorer countries (the Balassa–Samuelson effect). That is why *The Economist* also publishes a GDP-adjusted index. The same logic is at the heart of [my own work](#part-iii-unequal-stargazing) on restaurant prices.

### 5. Real exchange rates and the REER

The nominal exchange rate tells you how many dollars a euro buys; the **real exchange rate** tells you how many foreign *baskets* a home basket buys. Let $E$ be the price of one unit of home currency in foreign currency (e.g. dollars per euro):

$$
Q = \frac{E \, P}{P^*}
$$

A rise in $Q$ is a **real appreciation**: home goods become dearer relative to foreign goods. The Big Mac Index is simply a one-good real exchange rate: $Q^{BM} = 1 + V$.

The **real effective exchange rate (REER)** aggregates bilateral real exchange rates across trading partners $k$, using trade weights $w_k$ that sum to one:

$$
REER = \prod_{k} \left( \frac{E_k \, P}{P_k} \right)^{w_k}, \qquad \sum_k w_k = 1
$$

It is usually expressed as an index (base year = 100), with prices measured by consumer prices, GDP deflators or unit labour costs. A rising REER signals a loss of price competitiveness. For euro area countries, the ECB publishes REERs as **Harmonised Competitiveness Indicators**. For food, a real appreciation makes exports such as French wine or Irish dairy dearer for foreign buyers, even if their prices at home have not changed.

## Part II. Recent articles on the economics of food

### Luxury goods are out, but luxury travel is in
*The Economist*, October 2025 · [Read the article](https://www.economist.com/business/2025/10/06/luxury-goods-are-out-but-luxury-travel-is-in)

Wealthy consumers are cutting back on handbags and shoes but still paying for luxury hotels, first-class flights and once-in-a-lifetime experiences. The article cites Bain's forecast that personal luxury goods sales will fall by 2–5% in 2025, and McKinsey's projection that luxury hospitality spending will rise from under USD 240bn in 2023 to over USD 390bn by 2028.

*Why it matters for food:* fine dining sits on the "experiences" side of this divide. In the language of Part I, high-end restaurants are superior goods with a strong Veblen component, and the shift from conspicuous *goods* to conspicuous *experiences* is a shift in where status signalling happens.

### Consumer boycotts: the impact of the Iraq war on French wine sales in the US
Larry Chavis and Phillip Leslie, *Quantitative Marketing and Economics*, 7(1), 2009 · [Stanford GSB working paper](https://www.gsb.stanford.edu/faculty-research/working-papers/consumer-boycotts-impact-iraq-war-french-wine-sales-us)

In 2003, France's opposition to the Iraq war prompted calls in the US to boycott French products. Using weekly scanner data from supermarkets and large retailers in four US cities, the authors estimate that the boycott lowered French wine sales by 26% at its peak and by 13% over the roughly six months it lasted. Neither political preferences nor media attention turn out to be important determinants of participation.

*Why it matters:* it is a rare clean measurement of a consumer boycott, and a reminder that demand for food also depends on identity and politics, not only on prices and income.

## Part III. Unequal Stargazing

*Initial research, work in progress.*

A Michelin star is meant to signal the same standard of cooking everywhere. But what a star *costs* differs a lot from one place to another: in euros, in purchasing power, and relative to what local people earn. **Unequal Stargazing** collects the menu prices of Michelin-recognised restaurants (from Bib Gourmand to three stars) and compares them in several ways:

- the **nominal price** of the menu, and the price **per course**;
- a **PPP-adjusted price**, using restaurant price levels for EU countries and the Big Mac Index elsewhere (see Part I, section 4);
- the price relative to **local GDP per head** and to **local wages**, a measure of how much economic effort the meal represents locally;
- the restaurant's **percentile** within its own country.

### How much does a star cost locally?

The chart below covers 159 one-star restaurants for which the number of courses is known, in France, Germany, Italy, Ireland, New Zealand and Spain. Each small dot is a restaurant; large dots are city averages. The vertical axis is the PPP-adjusted price per course; the horizontal axis is the menu price relative to local GDP per head. Scroll to zoom and drag to move around.

<iframe src="/unequal-stargazing/scatter.html" title="Unequal Stargazing: price per course vs local GDP per head" loading="lazy" style="width:100%;height:640px;border:0;border-radius:8px;"></iframe>

[Open the chart in a new tab](/unequal-stargazing/scatter.html)

An interactive map of every restaurant in the dataset, with its price, PPP equivalent and local-effort measures, is coming soon.

## References

- Bagwell, L. S. and Bernheim, B. D. (1996). Veblen effects in a theory of conspicuous consumption. *American Economic Review*, 86(3), 349–373.
- Chavis, L. and Leslie, P. (2009). Consumer boycotts: The impact of the Iraq war on French wine sales in the U.S. *Quantitative Marketing and Economics*, 7(1), 37–67.
- d'Aspremont, C., Gabszewicz, J. J. and Thisse, J.-F. (1979). On Hotelling's "Stability in competition". *Econometrica*, 47(5), 1145–1150.
- Hotelling, H. (1929). Stability in competition. *Economic Journal*, 39(153), 41–57.
- Hotelling, H. (1931). The economics of exhaustible resources. *Journal of Political Economy*, 39(2), 137–175.
- Jensen, R. T. and Miller, N. H. (2008). Giffen behavior and subsistence consumption. *American Economic Review*, 98(4), 1553–1577.
- Leibenstein, H. (1950). Bandwagon, snob, and Veblen effects in the theory of consumers' demand. *Quarterly Journal of Economics*, 64(2), 183–207.
- Veblen, T. (1899). *The Theory of the Leisure Class*. New York: Macmillan.
