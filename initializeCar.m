function car = initializeCar(index,t)

initializeDesiredSpeed = @() 40 + rand * 20;
initializeFrustration = @() rand;

car(index).index = index;
car(index).desiredSpeed = initializeDesiredSpeed();
car(index).frustration = initializeFrustration();
car(index).speed = 30 + rand * 30;
car(index).position = 0;
car(index).acceleration = 0;
car(index).time = t;
car = car(index);

end