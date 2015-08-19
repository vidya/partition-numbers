# Partition a Number

https://en.wikipedia.org/wiki/Partition_(number_theory)


This repository contains the first version of an iOS educational puzzle for partitioning a number,
into three parts. The app is written in Swift and uses the SpriteKit framework.

## Application Layout

The app displays three areas: Endpoints, TargetBricks and PartitionChoices.

Endpoints displays a 3x3 grid of numbers. The endpoints are chosen from top left to bottom right as 
the next number that needs to be partitioned.

TargetBricks displays a series of numbered bricks that go from 1 to the chosen endpoint.
The bricks are displayed in rows of ten each with numbers increasing from left to right and top to 
bottom.

PartitionChoics displays a single row containing three three blocks of three labelled Arrow Pouches.
The label on an arrow pouch indicates the number of arrows contained in the pouch.

## Solving the Puzzle

To solve the puzzle, select one pouch at a time from each block of pouches. As each pouch is selected
the arrows contained in the pouch are released and knock out the target bricks.

Your challenge is to select the correct set of three pouches, one from each block, so that all the bricks
constituting an endpoint get knocked out. If you succeed in knocking out an endpoint, the bricks 
corrresponding to the next endpoint are displayed. 

You win the game by knocking out the target bricks constituting each endpoint.

## Status of Game Features

This game is still in development. The following status indicates some of the missing features of the game.

5/8/15
------
o As of now, only correct partitions are detected. If an incorrect triplet is chosen as the partition of an endpoint number, no error indication is given. 
