from plotly import offline
import plotly.graph_objs as go
import pandas as pd
import os

os.chdir('H:\TCD\Semester 2\DataVisualization\Assignment2')

FILENAME='nightingale-data-1.xlsx'
SHEET='Sheet1'
YEAR1_APR1854_MAR1855=['Apr 1854','May 1854','Jun 1854','Jul 1854',
                       'Aug 1854','Sep 1854','Oct 1854','Nov 1854',
                       'Dec 1854','Jan 1855','Feb 1855','Mar 1855']
YEAR2_APR1855_MAR1856=['Apr 1855','May 1855','Jun 1855','Jul 1855',
                       'Aug 1855','Sep 1855','Oct 1855','Nov 1855',
                       'Dec 1855','Jan 1856','Feb 1856','Mar 1856']
TITLE_APR1854_MAR1855='April 1854 - March 1855'
TITLE_APR1855_MAR1856='April 1855 - March 1856'
PURPLE='rgb(106,81,163)'
PURPLE_LIGHT='rgb(158,154,200)'
PURPLE_LIGHTEST='rgb(203,201,226)'
BLUE='rgb(51, 236, 255)'
RED='rgb(210, 80, 80)'
BLACK='rgb(151, 139, 139)'
ZYMOTIC='Zymotic diseases'
WOUNDS='Wounds & injuries'
OTHERS='All other causes'
DIRECTION_VALUE='clockwise'
ROTATION_VALUE=160
SIZE_VALUE=14
WIDTH_NORMAL=1.5
WIDTH_ZOOMED=0.75
FLAG_RESIZE=0

nightangle_data=pd.read_excel(FILENAME,sheet_name=SHEET)


def createWindrose(year,values,color_z, color_w, color_o,width_received):
    trace1 = go.Barpolar(
        r=values[ZYMOTIC],
        theta=year,
        name=ZYMOTIC,
        marker=dict(
            color=color_z,
            line=dict(
                    width=width_received)
        )
    )
    trace2 = go.Barpolar(
        r=values[WOUNDS],
        theta=year,
        name=WOUNDS,
        marker=dict(
            color=color_w,
            line=dict(
                width=width_received)
        )
    )
    trace3 = go.Barpolar(
        r=values[OTHERS],
        theta=year,
        name=OTHERS,
        marker=dict(
            color=color_o,
                        line=dict(
                    width=width_received)
        )
    )
    data = [trace3, trace2, trace1]
    return data

def plot_fn(title_received, data,ROTATION_VALUE):
    layout = go.Layout(
         title=title_received,
         font=dict(
             size=SIZE_VALUE
         ),
         legend=dict(
             font=dict(
                 size=SIZE_VALUE
                 )
         ),
         polar = dict(
            bargap=0,
          angularaxis=dict(
             visible=True,
             ticklen=0,
             showline=True,
             showgrid=True,
             showticklabels=True,
             direction=DIRECTION_VALUE,
             rotation=ROTATION_VALUE,
             #visible=False
          ),
          radialaxis=dict(
             visible=False,
             showgrid=True
         )
         
       ),
          #uncomment for resizing
              #width=1000,
              #height=750
    )

    fig = go.Figure(data=data, layout=layout)
    offline.plot(fig, filename=title_received+'.html')
    

year1_df, year2_df = nightangle_data.iloc[:12, : ], nightangle_data.iloc[12:, :]
#data1_APR1854_MAR1855=createWindrose(YEAR1_APR1854_MAR1855,year1_df, BLUE, RED, BLACK)
#data2_APR1855_MAR1856=createWindrose(YEAR2_APR1855_MAR1856,year2_df, PURPLE,PURPLE_LIGHT, PURPLE_LIGHTEST)
data2_APR1855_MAR1856=createWindrose(YEAR2_APR1855_MAR1856,year2_df, PURPLE,PURPLE_LIGHT,PURPLE_LIGHTEST,WIDTH_NORMAL)

#plot_fn(TITLE_APR1854_MAR1855, data1_APR1854_MAR1855,ROTATION_VALUE)
plot_fn(TITLE_APR1855_MAR1856, data2_APR1855_MAR1856,ROTATION_VALUE)
#plot_fn(TITLE_APR1854_MAR1855+' - Rotated and Zoomed', data1_APR1854_MAR1855,320)
data2_APR1855_MAR1856=createWindrose(YEAR2_APR1855_MAR1856,year2_df,BLUE, RED, BLACK,WIDTH_ZOOMED)
plot_fn(TITLE_APR1855_MAR1856+' - Rotated and Zoomed', data2_APR1855_MAR1856,90)