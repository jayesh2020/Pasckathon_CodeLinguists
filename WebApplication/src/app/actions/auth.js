import { auth, provider, firestore } from '../firebase/firebase';

// Check if user exists if not create a user
export const createUserProfileDocument = async (userAuth) => async (
  dispatch
) => {
  if (!userAuth) return;

  const userReference = firestore.doc(`users/${userAuth.uid}`);
  const snapShot = await userReference.get();
  console.log(snapShot);
  if (!snapShot.exists) {
    const { name, email } = userAuth;
    const createdAt = new Date();
    try {
      await userReference.set({
        name,
        email,
        createdAt,
      });
    } catch (error) {
      console.log(error);
    }
  }
  return userReference;
};

export const signInWithGoogle = () => {
  auth.signInWithPopup(provider);
};

export const loadUser = (uid) => async (dispatch) => {
  dispatch({
    type: 'LOAD_USER',
    payload: uid,
  });
};

export const setUser = (user) => async (dispatch) => {
  dispatch({
    type: 'SET_USER',
    payload: user,
  });
};
