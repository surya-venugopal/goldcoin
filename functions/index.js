
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const algoliasearch = require('algoliasearch');

admin.initializeApp();
const db = admin.firestore();

const algoliaClient = algoliasearch(functions.config().algolia.appid, functions.config().algolia.apikey);
const collectionIndex = algoliaClient.initIndex("stocklot_products");
const userCollectionIndex = algoliaClient.initIndex("stocklot_users");

exports.sendUserCollectionToAlgolia = functions.https.onRequest(async (req, res) => {

	const algoliaRecords = [];

	const querySnapshot = await db.collection('User').get();

	querySnapshot.docs.forEach(doc => {
		const document = doc.data();
        const record = {
            objectID: doc.id,
            personName: document.name,
			rating: document.rating,
			dp: document.dp,
        };

        algoliaRecords.push(record);
    });
	userCollectionIndex.saveObjects(algoliaRecords);
});


exports.userCollectionOnCreate = functions.firestore.document('User/{uid}').onCreate(async (snapshot, context) => {
        if (snapshot.exists) {
            const document = snapshot.data();
            const record = {
                        objectID: snapshot.id,
                        personName: document.name,
			            rating: document.rating,
			            dp: document.dp,
                    };

                    await userCollectionIndex.saveObject(record);

        }
});

exports.userCollectionOnUpdate = functions.firestore.document('User/{uid}').onUpdate(async (change, context) => {
        const docBeforeChange = change.before.data()
        const docAfterChange = change.after.data()
        if (docBeforeChange && docAfterChange) {

            if (docAfterChange.isIncomplete && !docBeforeChange.isIncomplete) {
                if (change.after.exists) {
                            const objectID = change.after.id;
                            await userCollectionIndex.deleteObject(objectID);
                        }
            } else if (docAfterChange.isIncomplete === false) {
                        if (change.after.exists) {
                            const document = change.after.data();
                            const record = {
                                        objectID: change.after.id,
                                        personName: document.name,
                                        rating: document.rating,
                                        dp: document.dp,
                                    };

                                    await userCollectionIndex.saveObject(record);

                        }
            }
        }
});

exports.userCollectionOnDelete = functions.firestore.document('User/{uid}').onDelete(async (snapshot, context) => {
        if (snapshot.exists) {
            const objectID = snapshot.id;
            await userCollectionIndex.deleteObject(objectID);
        }
});



//exports.sendCollectionToAlgolia = functions.https.onRequest(async (req, res) => {
//
//	const algoliaRecords = [];
//
//	const querySnapshot = await db.collection('Product').get();
//
//	querySnapshot.docs.forEach(doc => {
//		const document = doc.data();
//        const record = {
//            objectID: doc.id,
//            personName: document.personName,
//			title: document.title,
//			description: document.description,
//			imageUrl:document.imageUrl[0]
//        };
//
//        algoliaRecords.push(record);
//    });
//
//	collectionIndex.saveObjects(algoliaRecords);
//
//});
//
//exports.collectionOnCreate = functions.firestore.document('Product/{uid}').onCreate(async (snapshot, context) => {
//        if (snapshot.exists) {
//            const document = snapshot.data();
//            const record = {
//                        objectID: snapshot.id,
//                        personName: document.personName,
//            			title: document.title,
//            			description: document.description,
//            			imageUrl:document.imageUrl[0]
//                    };
//
//                    await collectionIndex.saveObject(record);
//
//        }
//});
//
//exports.collectionOnUpdate = functions.firestore.document('Product/{uid}').onUpdate(async (change, context) => {
//        const docBeforeChange = change.before.data()
//        const docAfterChange = change.after.data()
//        if (docBeforeChange && docAfterChange) {
//
//            if (docAfterChange.isIncomplete && !docBeforeChange.isIncomplete) {
//                if (change.after.exists) {
//                            const objectID = change.after.id;
//                            await collectionIndex.deleteObject(objectID);
//                        }
//            } else if (docAfterChange.isIncomplete === false) {
//                        if (change.after.exists) {
//                            const document = change.after.data();
//                            const record = {
//                                        objectID: change.after.id,
//                                        personName: document.personName,
//                            			title: document.title,
//                            			description: document.description,
//                            			imageUrl:document.imageUrl[0]
//                                    };
//
//                                    await collectionIndex.saveObject(record);
//
//                        }
//            }
//        }
//});
//
//exports.collectionOnDelete = functions.firestore.document('Product/{uid}').onDelete(async (snapshot, context) => {
//        if (snapshot.exists) {
//            const objectID = snapshot.id;
//            await collectionIndex.deleteObject(objectID);
//        }
//});
