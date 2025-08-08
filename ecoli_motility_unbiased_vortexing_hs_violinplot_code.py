import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np

# Your data
v_5sec = [19.67, 19.84, 17.65, 14.95, 17.27, 18.92, 20.97, 24.07, 23.36, 20.71, 21.58, 21.90, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00]
v_15sec = [37.97, 35.82, 32.43, 20.63, 25.81, 27.42, 33.33, 29.70, 30.39, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00]
v_30sec = [45.78, 47.22, 42.86, 62.38, 60.23, 67.95, 53.26, 47.83, 52.44, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00]
v_60sec = [2.88, 0.71, 1.46, 6.33, 1.64, 6.35, 2.38, 2.27, 2.33, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 1.72, 0.00, 8.04, 5.13, 8.26, 0.00, 0.00, 0.00]
hs = [
    0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00,
    15.27, 10.00, 3.13, 18.00, 13.73, 7.41, 6.67, 5.00, 11.11, 14.52, 9.09,
    19.35, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00,
    0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00
]

# Prepare the data in a tidy format
df = pd.DataFrame({
    'Percentage of Motile Cells (%)': v_5sec + v_15sec + v_30sec + v_60sec + hs,
    'Separation Technique': ['V-5sec'] * len(v_5sec) + ['V-15sec'] * len(v_15sec) + ['V-30sec'] * len(v_30sec) + ['V-60sec'] * len(v_60sec)
    + ['HS'] *len(hs)
})

print(df)

# Define custom colors for each group
colors_15 = [
    "#1f77b4",  # muted blue
    "#ff7f0e",  # safety orange
    "#2ca02c",  # cooked asparagus green
    "#d62728",  # brick red
    "#9467bd",  # muted purple
    "#8c564b",  # chestnut brown
    "#e377c2",  # raspberry yogurt pink
    "#7f7f7f",  # middle gray
    "#bcbd22",  # curry yellow-green
    "#17becf",  # blue-teal
    "#393b79",  # dark slate blue
    "#637939",  # olive green
    "#8c6d31",  # dark goldenrod
    "#843c39",  # dark red
    "#7b4173"   # dark orchid
]

my_colors = {'V-5sec': colors_15[0], 'V-15sec': colors_15[14], 'V-30sec': colors_15[1], 'V-60sec': colors_15[13], 'HS': colors_15[2]}


plt.figure(figsize=(15, 10))
#sns.violinplot(x='Group', y='Value', data=df, inner='box', linewidth=1.2)
sns.violinplot(
    x='Separation Technique',
    y='Percentage of Motile Cells (%)',
    data=df,
    palette=my_colors,
    width=0.5,
    saturation=0.6,  # Adjust this value (0 to 1) for desired color intensity
    #inner='box',
    #inner='quart',
    inner='point', 
    linewidth=3
)
#sns.stripplot(
#    x='Group',
#    y='Value',
#    data=df,
#    color='black',
#    size=8,
#    jitter=True,
#    alpha=0.7
#)

plt.xlabel('Separation Technique', fontsize=18)  # x-axis label size
plt.ylabel('Percentage of Motile Cells (%)', fontsize=18)  # y-axis label size
plt.xticks(fontsize=14)  # x-tick label size
plt.yticks(fontsize=14)  # y-tick label size

#plt.title('Preliminary experiments - Vortexing + Hand Shaking')
plt.show()

print(f"vortex 5 seconds = {np.median(v_5sec)}")
print(f"vortex 15 seconds = {np.median(v_15sec)}")
print(f"vortex 30 seconds = {np.median(v_30sec)}")
print(f"vortex 60 seconds = {np.median(v_60sec)}")
print(f"hand-shaking = {np.median(hs)}")