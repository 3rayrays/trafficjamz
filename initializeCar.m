function car = initializeCar(index)

initializeDesiredSpeed = @() 40 + rand * 20;
initializeFrustration = @() rand;

car(index).index = index;
car(index).desiredSpeed = initializeDesiredSpeed();
car(index).frustration = initializeFrustration();
car(index).acceleration = calcAcceleration(car(index).frustration);
car(index).position = 0;
car = car(index);

end