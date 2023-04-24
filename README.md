# RESTful Service for Virtual Clinic App

Project of a virtual clinic web application enabling clinics to automate interactions with their patients.</br>
Created under [HTD Health](https://github.com/HTD-Health)’s guidance❤️.

## This is a RESTful service for [Virtual Clinic](https://github.com/AverageDanteEnjoyer/virtual-clinic-web) App.

## Tech Stack

- Ruby on Rails
- JWT Authentication
- PostgreSQL

## Features

Authentication:
- [x] Patient / Doctor registration
- [x] Login / Logout
- [x] Account deletion

Doctor's professions:
- [x] List professions
- [x] List doctor's professions
- [x] Manage doctor's professions

Doctor's procedures:
- [x] List procedures
- [x] List doctor's procedures
- [x] Manage doctor's procedures

Doctor's working hours:
- [x] Manage doctor's working hours
- [x] List doctor's schedule

Appointments:
- [x] List doctor's appointments
- [x] List patient's appointments
- [x] Book appointment
- [x] Cancel appointment

## Requirements

- `ruby '3.0.4'`
- `postgresql 14.X`

To authorize requests, you need to attach a valid JWT token to the `Authorization: Bearer <token>` header of each request.

## To run the project locally

Create file with name `.env` in main folder and add environment variables:
```
DB_NAME=<db_name>
DB_USERNAME=<username>
DB_PASSWORD=<password>
```
