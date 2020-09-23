import { createStore, combineReducers, applyMiddleware, compose } from 'redux';
import thunk from 'redux-thunk';
import authReducer from '../reducers/authReducer';
import dashFuncReducer from '../reducers/dashFuncReducer';
import docDashFuncReducer from '../reducers/docDashFuncReducer';
import doctorSearchReducer from '../reducers/doctorSearchReducer';
import infoReducer from '../reducers/infoReducer';
import predictReducer from '../reducers/predictReducer';

const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;

export default () => {
  const store = createStore(
    combineReducers({
      auth: authReducer,
      info: infoReducer,
      predict: predictReducer,
      doctorSearch: doctorSearchReducer,
      dashFunc: dashFuncReducer,
      docDashFunc: docDashFuncReducer,
    }),
    composeEnhancers(applyMiddleware(thunk))
  );
  return store;
};
