import plotly.graph_objects as go
import numpy as np
import networkx as nx

## Code for this graph generously donated from:
# https://plotly.com/python/network-graphs/

## importing matrix
matrix = np.genfromtxt('Adjacency_matrix.csv', delimiter = ",")
list = np.genfromtxt('Adjacency_list.csv', delimiter = ",")

## Turning adjacency matrix to graph obkect
G = nx.from_numpy_array(matrix,create_using=nx.DiGraph)

## Using a spiral layout to show centrality
pos = nx.spiral_layout(G)

## Adding position based on the layout
for i in range(0,42):
    for g in range(0,42):
        G.nodes[i]['pos'] = pos[i]
        G.nodes[g]['pos'] = pos[g]

## Adding edges together
edge_x = []
edge_y = []
for edge in G.edges():
    x0, y0 = G.nodes[edge[0]]['pos']
    x1, y1 = G.nodes[edge[1]]['pos']
    edge_x.append(x0)
    edge_x.append(x1)
    edge_x.append(None)
    edge_y.append(y0)
    edge_y.append(y1)
    edge_y.append(None)

## arranging them into lines
edge_trace = go.Scatter(
    x=edge_x, y=edge_y,
    line=dict(width=0.5, color='#888'),
    hoverinfo='none',
    mode='lines')

## adding nodes to graph
node_x = []
node_y = []
for node in G.nodes():
    x, y = pos[node]
    node_x.append(x)
    node_y.append(y)

## assembly again
node_trace = go.Scatter(
    x=node_x, y=node_y,
    mode='markers',
    hoverinfo='text',
    marker=dict(
        showscale=True,
        # colorscale options
        #'Greys' | 'YlGnBu' | 'Greens' | 'YlOrRd' | 'Bluered' | 'RdBu' |
        #'Reds' | 'Blues' | 'Picnic' | 'Rainbow' | 'Portland' | 'Jet' |
        #'Hot' | 'Blackbody' | 'Earth' | 'Electric' | 'Viridis' |
        colorscale='YlGnBu',
        reversescale=True,
        color=[],
        size=10,
        colorbar=dict(
            thickness=15,
            title='Node Connections',
            xanchor='left',
            titleside='right'
        ),
        line_width=2))

## Offenses for tooltip
offenses_list = [ "Destruction/Damage/Vandalism of Property",    "Theft From Motor Vehicle"  ,                 
  "Robbery"                      ,               "Simple Assault"           ,                  
  "Intimidation"                 ,               "All Other Larceny"         ,                 
  "Motor Vehicle Theft"           ,              "Drug Equipment Violations" ,                 
 "Drug/Narcotic Violations"     ,               "Weapon Law Violations"     ,                 
 "Stolen Property Offenses"     ,               "Aggravated Assault"        ,                 
 "Purse-snatching"              ,               "Extortion/Blackmail"         ,               
 "Theft From Building"          ,               "Fondling"                  ,                 
 "Counterfeiting/Forgery"       ,               "Theft of Motor Vehicle Parts or Accessories",
 "Credit Card/Automated Teller Machine Fraud" , "Impersonation"      ,                        
 "Pocket-picking"                     ,         "Kidnapping/Abduction"     ,                  
 "False Pretenses/Swindle/Confidence Game"   ,  "Burglary/Breaking & Entering"       ,        
 "Rape"                      ,                  "Murder and Nonnegligent Manslaughter"   ,    
 "Theft From Coin-Operated Machine or Device" , "Animal Cruelty"          ,                   
 "Shoplifting"             ,                    "Hacking/Computer Invasion"      ,            
 "Identity Theft"         ,                     "Wire Fraud"                ,                 
 "Arson"                 ,                      "Betting/Wagering"         ,                  
 "Welfare Fraud"        ,                       "Pornography/Obscene Material"     ,          
 "Bribery"           ,                          "Purchasing Prostitution"       ,             
 "Prostitution"                 ,               "Sodomy"                 ,                    
 "Sexual Assault With An Object", "Other"]

# getting tooltip
node_adjacencies = []
node_text = []
for node, adjacencies in enumerate(G.adjacency()):
    node_adjacencies.append(len(adjacencies[1]))
    node_text.append('# of connections: '+str(len(adjacencies[1])) + " | Offense Type: " + offenses_list[node])

node_trace.marker.color = node_adjacencies
node_trace.text = node_text

## Plotting the figure
fig = go.Figure(data=[edge_trace, node_trace],
             layout=go.Layout(
                title='Amount of times an Offense is Listed with other Ofenses',
                titlefont_size=16,
                showlegend=False,
                hovermode='closest',
                margin=dict(b=20,l=5,r=5,t=40),
                annotations=[ dict(
                    text="",
                    showarrow=False,
                    xref="paper", yref="paper",
                    x=0.005, y=-0.002 ) ],
                xaxis=dict(showgrid=False, zeroline=False, showticklabels=False),
                yaxis=dict(showgrid=False, zeroline=False, showticklabels=False))
                )
fig.show()