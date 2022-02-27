<?php
// Hold declarations for all database communication functions that can be called
// by Flutter. For now, this will be user authentication, getting a list of events (basic data),
// and getting detailed info about one event.

  function connectDB(){
    //Initializes database    
  }

  function getFriends(){
   //Returns list of friends with desired information
   //such as name, email, registered events with the exception of password
  }

  function getEvents(){
    //returns list of events  
  }

  function getEventsDay(timestamp day){
    //Returns events on given day
  }

  function signupEvents(int id, char(40) email){
    // No return, signs up user for desired event
  }

  function createFriend(char(40) email, char(100) password, char(100) name, text intro, char(40) contact, tinyint(1) admin){
    //creates user in DB 
  }

  function createEvent(char(40) email, char(100) title, text description, int slots, int category, tinyint(1) reported, timestamp date_created){
   //creates event 
  }


?>
