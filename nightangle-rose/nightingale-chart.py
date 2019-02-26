import plotly.plotly as py
from plotly import offline
import plotly.graph_objs as go
import pandas as pd

nightangle_data=pd.read_excel("nightingale-data-1.xlsx",sheet_name="Sheet1")
year1=['Apr 1854','May 1854','Jun 1854','Jul 1854','Aug 1854','Sep 1854','Oct 1854','Nov 1854','Dec 1854','Jan 1855','Feb 1855','Mar 1855']
year2=['Apr 1855','May 1855','Jun 1855','Jul 1855','Aug 1855','Sep 1855','Oct 1855','Nov 1855','Dec 1855','Jan 1856','Feb 1856','Mar 1856']

data=[]

def createWindrose(year,values):
    global data
    trace1 = go.Barpolar(
        r=nightangle_data['Zymotic diseases'],
        theta=year1,
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
    return data
    

year1, year2 = nightangle_data[:11, :], nightangle_data[12:, :]

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




