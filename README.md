# Open-Source-Modules

All modules here are made by me

Feel free to use them whilst abiding by the license of this repository


> __**The projects below are all using the modules in this repository**__



# Ocean
![Water benchmark](https://user-images.githubusercontent.com/81488914/113968432-fae08a80-982a-11eb-97db-2a99281fdfae.png)
[Water gif (gyazo)](https://i.gyazo.com/e5f71390cb16ed65216e265e9ca0b6ac.mp4)


**Modules:**
- Waves
- Chunks


**Overview:**

For this I created the waves and chunks modules. At first it was incredible unoptimised, where each frame would take about 100ms to load but through a lot of painful tests and designing algorithms I managed to lower it to ~20ms for updating the transformation matrices of  6400 (16^2\*5^2) bones, of which the majority are visible on the screen by passing in the unit vector of where your camera is facing into the chunk module, allowing only visible chunks to be loaded. If I was to make the environment more foggy I would be able to use smaller and less chunks, speeding up the process greatly. To put this into perspective, it takes ~3ms to update 729 (9^2\*3^2) bones.
The wave function I use is a gerstner (also known as trochoidal) wave. Optimising this function was vital to making the water as efficient as possible, as with every bone updated this function would be run once. Because of this, I cached repeated mathematical operations and made variables for methods of the built-in math module so I did not have to spend time indexing the methods. Furthermore, I made sure to do as much of the maths in C++ as Roblox allowed me, as it runs far faster. With this, I managed to make the function ~0.02ms.
For extra effect I added floating objects and swimming where the surface normal of the waves was calculated and taken into account along with the height of the wave at the position an object. If the camera goes below the water some blur effects are put into place as well.
In the end, I am quite happy with how this project has gone, but if I were to do it again I would have experimented with perlin noise, as a C++ function for it is implemented into luau, making it far faster. However, I think this would have sacrified some of the quality of the water, as gerstner waves are very realistic for non physics based fluid simulations.
