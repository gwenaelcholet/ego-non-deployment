db.createUser({
    user: 'egonon',
    pwd: 'egonon2022!',
    roles: [
        {
            role: 'readWrite',
            db: 'EgoNon',
        },
    ],
});

db = new Mongo().getDB("EgoNon");