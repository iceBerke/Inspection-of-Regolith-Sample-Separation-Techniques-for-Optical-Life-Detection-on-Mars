import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np

# Your data
mgs1_inc_v_5sec = [20.58, 1.37, 1.70]
print(np.mean(mgs1_inc_v_5sec))

mgs1_inc_v_15sec = [0.56, 0.64, 0.92]
print(np.mean(mgs1_inc_v_15sec))

mgs1_inc_v_30sec = [2.07, 3.03, 2.52]
print(np.mean(mgs1_inc_v_30sec))

mgs1_inc_v_60sec = [0.72, 11.13, 4.23]
print(np.mean(mgs1_inc_v_60sec))

mgs1_inc_v_300sec = [240.06, 9.86]
print(np.mean(mgs1_inc_v_300sec))

mgs1_inc_hs = [36.62, 65.59, 115.28]
print(np.mean(mgs1_inc_hs))

# Prepare the data in a tidy format
df = pd.DataFrame({
    'Percentage of Extracted Cells Relative to Control (%)': mgs1_inc_v_5sec + mgs1_inc_v_15sec + mgs1_inc_v_30sec + mgs1_inc_v_60sec + mgs1_inc_v_300sec + mgs1_inc_hs,
    'Separation Technique': ['V-5sec'] * len(mgs1_inc_v_5sec) + ['V-15sec'] * len(mgs1_inc_v_15sec) + ['V-30sec'] * len(mgs1_inc_v_30sec) + ['V-60sec'] * len(mgs1_inc_v_60sec)
    + ['V-300sec'] * len(mgs1_inc_v_300sec) + ['HS'] *len(mgs1_inc_hs)
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

my_colors = {'V-5sec': colors_15[0], 'V-15sec': colors_15[14], 'V-30sec': colors_15[1], 'V-60sec': colors_15[13], 'V-300sec': colors_15[2], 'HS': colors_15[12]}

plt.figure(figsize=(15, 10))
#sns.violinplot(x='Group', y='Value', data=df, inner='box', linewidth=1.2)
sns.violinplot(
    x='Separation Technique',
    y='Percentage of Extracted Cells Relative to Control (%)',
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
plt.ylabel('Percentage of Extracted Cells Relative to Control (%)', fontsize=18)  # y-axis label size
plt.xticks(fontsize=14)  # x-tick label size
plt.yticks(fontsize=14)  # y-tick label size

plt.title('Main experiments - MGS-1 + Incubation', fontsize=20)
plt.show()

print(f"MGS-1 + Inc + V5 = {np.median(mgs1_inc_v_5sec)}")
print(f"MGS-1 + Inc + V15 = {np.median(mgs1_inc_v_15sec)}")
print(f"MGS-1 + Inc + V30 = {np.median(mgs1_inc_v_30sec)}")
print(f"MGS-1 + Inc + V60 = {np.median(mgs1_inc_v_60sec)}")
print(f"MGS-1 + Inc + V300 = {np.median(mgs1_inc_v_300sec)}")
print(f"MGS-1 + Inc + HS = {np.median(mgs1_inc_hs)}")