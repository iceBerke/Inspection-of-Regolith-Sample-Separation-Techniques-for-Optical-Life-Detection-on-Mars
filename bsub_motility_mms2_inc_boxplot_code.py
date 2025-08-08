import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np

# Your data
mms2_inc_v_5sec = [25.36, 11.62, 24.80, 29.37, 26.57, 178.68, 174.64, 174.36, 144.26]
print(np.mean(mms2_inc_v_5sec))

mms2_inc_v_15sec = [134.89, 117.37, 177.13, 185.99, 107.20, 106.87, 100.91, 81.92, 158.43, 140.46, 123.37, 167.05]
print(np.mean(mms2_inc_v_15sec))

mms2_inc_v_30sec = [38.86, 50.95, 18.60, 31.52, 84.91, 58.45, 183.25, 142.91, 119.15, 128.80, 117.79, 123.99, 83.07]
print(np.mean(mms2_inc_v_30sec))

mms2_inc_v_60sec = [140.75, 144.30, 164.25, 184.79, 107.01, 130.44, 144.94, 187.15, 104.44, 89.61, 52.43, 62.00, 61.67]
print(np.mean(mms2_inc_v_60sec))

mms2_inc_v_120sec = [96.81, 86.04, 80.06, 66.87, 43.28, 41.38, 15.26, 11.52, 36.71, 67.11, 68.42, 47.68, 45.51]
print(np.mean(mms2_inc_v_120sec))

mms2_inc_v_300sec = [43.25, 32.85, 64.90, 69.97, 63.98, 55.33, 50.16, 66.26, 62.12, 48.04, 35.52, 29.78, 28.70, 33.48, 29.06]
print(np.mean(mms2_inc_v_300sec))

mms2_inc_hs = [59.89, 36.76, 42.68, 57.72, 84.13, 105.04, 92.34, 100.95, 117.02, 101.56, 103.75, 96.38, 90.49, 92.99, 93.48]
print(np.mean(mms2_inc_hs))

# Prepare the data in a tidy format
df = pd.DataFrame({
    'Percentage of Motile Extracted Cells Relative to Control (%)': mms2_inc_v_5sec + mms2_inc_v_15sec + mms2_inc_v_30sec + mms2_inc_v_60sec + mms2_inc_v_120sec 
    + mms2_inc_v_300sec + mms2_inc_hs,
    'Separation Technique': ['V-5sec'] * len(mms2_inc_v_5sec) + ['V-15sec'] * len(mms2_inc_v_15sec) + ['V-30sec'] * len(mms2_inc_v_30sec) + ['V-60sec'] * len(mms2_inc_v_60sec)
    + ['V-120sec'] * len(mms2_inc_v_120sec) + ['V-300sec'] * len(mms2_inc_v_300sec) + ['HS'] *len(mms2_inc_hs)
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

my_colors = {'V-5sec': colors_15[0], 'V-15sec': colors_15[14], 'V-30sec': colors_15[1], 'V-60sec': colors_15[13], 'V-120sec':colors_15[2], 'V-300sec': colors_15[12], 
             'HS': colors_15[3]}


plt.figure(figsize=(15, 10))
sns.boxplot(
    x='Separation Technique',
    y='Percentage of Motile Extracted Cells Relative to Control (%)',
    data=df,
    palette=my_colors,
    width=0.5,
    saturation=0.6  # Adjust this value (0 to 1) for desired color intensity
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

# Limit the y-axis range to, for example, 0 to 1000
#ax.set_ylim(0, 2000)

plt.xlabel('Separation Technique', fontsize=18)  # x-axis label size
plt.ylabel('Percentage of Motile Extracted Cells Relative to Control (%)', fontsize=18)  # y-axis label size
plt.xticks(fontsize=14)  # x-tick label size
plt.yticks(fontsize=14)  # y-tick label size

plt.title('Main experiments - MMS-2 + Incubation - Motility Plot', fontsize=20)
plt.show()

print(f"MMS-2 + Inc + V5 = {np.median(mms2_inc_v_5sec)}")
print(f"MMS-2 + Inc + V15 = {np.median(mms2_inc_v_15sec)}")
print(f"MMS-2 + Inc + V30 = {np.median(mms2_inc_v_30sec)}")
print(f"MMS-2 + Inc + V60 = {np.median(mms2_inc_v_60sec)}")
print(f"MMS-2 + Inc + V120 = {np.median(mms2_inc_v_120sec)}")
print(f"MMS-2 + Inc + V300 = {np.median(mms2_inc_v_300sec)}")
print(f"MMS-2 + Inc + HS = {np.median(mms2_inc_hs)}")
