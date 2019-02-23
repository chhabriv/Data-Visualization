import plotly.plotly as py
from plotly import offline
import plotly.graph_objs as go

# =============================================================================
# trace1 = go.Barpolar(
#     r=[1.4,0,7],
#     text=["Zymotic diseases","Wounds & injuries","All other causes"],
#     name='Apr',
#     marker=dict(
#         color='rgb(106,81,163)'
#     )
# )
# trace2 = go.Barpolar(
#     r=[6.2,0,4.6],
#     #r=[57.49999999999999, 50.0, 45.0, 35.0, 20.0, 22.5, 37.5, 55.00000000000001],
#     text=["Zymotic diseases","Wounds & injuries","All other causes"],
#     #text=['North', 'N-E', 'East', 'S-E', 'South', 'S-W', 'West', 'N-W'],
#     name='May 1854',
#     marker=dict(
#         color='rgb(158,154,200)'
#     )
# )
# trace3 = go.Barpolar(
#     r=[4.7,0,2.5],
#     text=["Zymotic diseases","Wounds & injuries","All other causes"],
#     name='Jun',
#     marker=dict(
#         color='rgb(203,201,226)'
#     )
# )
# trace4 = go.Barpolar(
#     r=[150,0,9.6],
#     text=["Zymotic diseases","Wounds & injuries","All other causes"],
#     name='Jul',
#     marker=dict(
#         color='rgb(242,240,247)'
#     )
# )
# =============================================================================

trace1 = go.Barpolar(
    r=[1.4,
6.2,
4.7,
150,
328.5,
312.2,
197,
340.6,
631.5,
1022.8,
822.8,
480.3,
],
    text=['Apr 1854','May 1854','Jun 1854','Jul 1854','Aug 1854','Sep 1854','Oct 1854','Nov 1854','Dec 1854','Jan 1855','Feb 1855','Mar 1855'],
    name='Zymotic diseases',
    marker=dict(
        color='rgb(106,81,163)'
    )
)
trace2 = go.Barpolar(
    r=[0,
0,
0,
0,
0.4,
32.1,
51.7,
115.8,
41.7,
30.7,
16.3,
12.8,
],
    text=['Apr 1854','May 1854','Jun 1854','Jul 1854','Aug 1854','Sep 1854','Oct 1854','Nov 1854','Dec 1854','Jan 1855','Feb 1855','Mar 1855'],
    name='Wounds & injuries',
    marker=dict(
        color='rgb(158,154,200)'
    )
)
trace3 = go.Barpolar(
    r=[7,
4.6,
2.5,
9.6,
11.9,
27.7,
50.1,
42.8,
48,
120,
140.1,
68.6,
],
    text=['Apr 1854','May 1854','Jun 1854','Jul 1854','Aug 1854','Sep 1854','Oct 1854','Nov 1854','Dec 1854','Jan 1855','Feb 1855','Mar 1855'],
    name='All other causes',
    marker=dict(
        color='rgb(203,201,226)'
    )
)
data = [trace3, trace2, trace1]
layout = go.Layout(
     title='Wind Speed Distribution in Laurel, NE',
     font=dict(
         size=16
     ),
     legend=dict(
         font=dict(
             size=16         )
     ),
     angularaxis=dict(
         #ticksuffix='%',
        #showline=False,
        showticklabels=True,
        #visible=False
     ),
     radialaxis=dict(
        ticksuffix='%'
    ),
     orientation=270
)
fig = go.Figure(data=data, layout=layout)
offline.plot(fig, filename='polar-area-chart')




