import plotly.plotly as py
from plotly import tools
from plotly import offline
import plotly.graph_objs as go
import pandas as pd


nightangle_data=pd.read_excel("nightingale-data-1.xlsx",sheet_name="Sheet1")
year1=['Apr 1854','May 1854','Jun 1854','Jul 1854','Aug 1854','Sep 1854','Oct 1854','Nov 1854','Dec 1854','Jan 1855','Feb 1855','Mar 1855']
year2=['Apr 1855','May 1855','Jun 1855','Jul 1855','Aug 1855','Sep 1855','Oct 1855','Nov 1855','Dec 1855','Jan 1856','Feb 1856','Mar 1856']
title_plot1='April 1854 - March 1855'
title_plot2='April 1855 - March 1856'

def createWindrose(year,values):
    trace1 = go.Barpolar(
        r=values['Zymotic diseases'],
        theta=year,
        name='Zymotic diseases',
        subplot = "polar1",
        marker=dict(
            color='rgb(30,144,255)'
        )
    )
    trace2 = go.Barpolar(
        r=values['Wounds & injuries'],
        theta=year,
        name='Wounds & injuries',
        subplot = "polar1",
        marker=dict(
            color='rgb(220,20,60)'
        )
    )
    trace3 = go.Barpolar(
        r=values['All other causes'],
        theta=year,
        name='All other causes',
        subplot = "polar1",
        marker=dict(
            color='rgb(0,0,0)'
        )
    )
    data = [trace3, trace2, trace1]
    return data

def plot_fn(title_received, data):
    layout = go.Layout(
         title=title_received,
         font=dict(
             size=16
         ),
         legend=dict(
             font=dict(
                 size=16         )
         ),
        radialaxis=dict(
            ticksuffix='%'            
        ),
         polar = dict(
          angularaxis=dict(
             visible=True,
             ticklen=0,
             showline=True,
             showgrid=True,
             showticklabels=True,
             #visible=False
          ),
          radialaxis=dict(
             visible=False,
             showgrid=True
         ),
                  sector=dict(
                          bargap=0
                )
         
       ),
        orientation=270
    )

    fig = go.Figure(data=data, layout=layout)
    offline.plot(fig, filename=title_received+'.html')
    

year1D, year2D = nightangle_data.iloc[:12, : ], nightangle_data.iloc[12:, :]
data1=createWindrose(year1,year1D)
data2=createWindrose(year2,year2D)

plot_fn(title_plot1, data1)
plot_fn(title_plot2, data2)

if __init__ == main():
    

######################################-------------------------##############################################


#####################################---------------------------##############################################

def createWindrose2(values1,values2):
    trace1 = go.Barpolar(
        r=values1['Zymotic diseases'],
        theta=year1,
        name='Zymotic diseases',
        subplot = "polar1",
        marker=dict(
            color='rgb(106,81,163)'
        )
    )
    trace2 = go.Barpolar(
        r=values1['Wounds & injuries'],
        theta=year1,
        name='Wounds & injuries',
        subplot = "polar1",
        marker=dict(
            color='rgb(158,154,200)'
        )
    )
    trace3 = go.Barpolar(
        r=values1['All other causes'],
        theta=year1,
        name='All other causes',
        subplot = "polar1",
        marker=dict(
            color='rgb(203,201,226)'
        )
    )
    trace4 = go.Barpolar(
        r=values2['Zymotic diseases'],
        theta=year2,
        name='Zymotic diseases',
        subplot = "polar2",
        marker=dict(
            color='rgb(106,81,163)'
        )
    )
    trace5 = go.Barpolar(
        r=values2['Wounds & injuries'],
        theta=year2,
        name='Wounds & injuries',
        subplot = "polar2",
        marker=dict(
            color='rgb(158,154,200)'
        )
    )
    trace6 = go.Barpolar(
        r=values2['All other causes'],
        theta=year2,
        name='All other causes',
        subplot = "polar2",
        marker=dict(
            color='rgb(203,201,226)'
        )
    )
    data = [trace3, trace2, trace1, trace6, trace5, trace4]
    return data

layout1   = go.Layout(
     title='Nightangles Rose',
     polar = dict(
     angularaxis=dict(
         #ticksuffix='%',
        #showline=False,
        showticklabels=True,
        #visible=False
     ),
     radialaxis=dict(
        ticksuffix='%'
    )
    ),
    polar2 =dict(
    angularaxis=dict(
         #ticksuffix='%',
        #showline=False,
        showticklabels=True,
        #visible=False
     ),
     radialaxis=dict(
        ticksuffix='%'
    ), 
      ),
      showlegend = False
)
     
data=createWindrose2(year1D,year2D)
fig = go.Figure(data=data, layout=layout1)
fig['layout'].update(height=2000, width=2000, title='Multiple Subplots' +
                                                  ' with Titles')

offline.plot(fig, filename='year1')

# =============================================================================
# app = dash.Dash()
# layout = html.Div(
#         [html.Div(plots[i], style=col_style[i]) for i in range(len(plots))],
#         style = {'margin-right': '0px'}
#     )
# 
# app.layout = layout
# app.run_server(port=8052)
# =============================================================================



