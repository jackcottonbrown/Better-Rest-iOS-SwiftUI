# Better Rest iOS SwiftUI

 Better Rest is an app that uses machine learning to predict the optimal time to go to bed based on desired sleep, and coffee consumption.
![Better Rest Gif](https://user-images.githubusercontent.com/63089587/156867865-294ff27c-b3b4-44c6-9595-2fedd054e23d.gif)

Core Features:
- Select desired wake up time
- Adjust desired amount of sleep
- Adjust daily number of cups of coffee drank
- Predict the optimal bed time 
- Use the ML model to perform real-time prediction updates on optimal bed time.

Design Considerations:
- Avoid negative values - sleep amount and coffee consumption should not be negative.
- Use sensible stepwise increments. 
- Use sensible ranges for the values.
- Update ML prediction upon any change in value to create real-time predictions.
