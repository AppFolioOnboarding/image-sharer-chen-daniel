/* eslint-env mocha */

import assert from 'assert';
import { mount } from 'enzyme';
import React from 'react';
import sinon from 'sinon';
import FeedbackForm from '../../components/FeedbackForm';
import * as api from '../../utils/helper';

describe('<FeedbackForm />', () => {
  it('should render correctly', () => {
    const wrapper = mount(<FeedbackForm />);

    const formGroup1 = wrapper.find('FormGroup').at(0);
    assert.strictEqual(formGroup1.length, 1);
    assert.strictEqual(formGroup1.find('Label').children().text(), 'Your Name');
    assert.strictEqual(formGroup1.find('Input').prop('type'), 'text');

    const formGroup2 = wrapper.find('FormGroup').at(1);
    assert.strictEqual(formGroup2.length, 1);
    assert.strictEqual(formGroup2.find('Label').children().text(), 'Comments');
    assert.strictEqual(formGroup2.find('Input').prop('type'), 'textarea');

    const submitButton = wrapper.find('Button');
    assert.strictEqual(submitButton.length, 1);
    assert.strictEqual(submitButton.children().text(), 'Submit');
  });

  it('should successfully submit form and reset inputs', () => {
    const wrapper = mount(<FeedbackForm />);

    wrapper.instance().name = 'Daniel';
    wrapper.instance().comments = 'Nice';
    wrapper.instance().alertMessage = 'Error';

    const e = { preventDefault: sinon.spy() };
    const stub = sinon.stub(api, 'post').resolves({
      message: 'Feedback successfully submitted'
    });

    return wrapper.instance().submitForm(e).then(() => {
      assert(e.preventDefault.calledOnce);
      assert(stub.calledOnceWithExactly('/api/feedbacks', { name: 'Daniel', comments: 'Nice' }));
      assert.strictEqual(wrapper.instance().name, '');
      assert.strictEqual(wrapper.instance().comments, '');
      assert.strictEqual(wrapper.instance().alertMessage, 'Feedback successfully submitted');
      assert.strictEqual(wrapper.instance().alertColor, 'info');
      stub.restore();
    });
  });

  it('should update UI with error fields on submit rejection', () => {
    const wrapper = mount(<FeedbackForm />);

    wrapper.instance().name = 'Daniel';
    wrapper.instance().comments = '';
    wrapper.instance().alertMessage = 'Feedback successfully submitted';

    const e = { preventDefault: sinon.spy() };
    const stub = sinon.stub(api, 'post').rejects({
      data: {
        comments: "can't be blank"
      }
    });

    return wrapper.instance().submitForm(e).then(() => {
      assert(e.preventDefault.calledOnce);
      assert(stub.calledOnceWithExactly('/api/feedbacks', { name: 'Daniel', comments: '' }));
      assert.strictEqual(wrapper.instance().name, 'Daniel');
      assert.strictEqual(wrapper.instance().comments, '');
      assert.strictEqual(wrapper.instance().nameFeedback, undefined);
      assert.strictEqual(wrapper.instance().commentsFeedback, "can't be blank");
      assert.strictEqual(wrapper.instance().alertMessage, undefined);
      stub.restore();
    });
  });

  it('should alert failure if there is some other error', () => {
    const wrapper = mount(<FeedbackForm />);

    wrapper.instance().name = 'Daniel';
    wrapper.instance().comments = 'This is a comment.';
    wrapper.instance().alertMessage = 'Feedback successfully submitted';

    const e = { preventDefault: sinon.spy() };
    const stub = sinon.stub(api, 'post').rejects({
      message: 'Failed to fetch'
    });

    return wrapper.instance().submitForm(e).then(() => {
      assert(e.preventDefault.calledOnce);
      assert(stub.calledOnceWithExactly('/api/feedbacks', {
        name: 'Daniel',
        comments: 'This is a comment.'
      }));
      assert.strictEqual(wrapper.instance().name, 'Daniel');
      assert.strictEqual(wrapper.instance().comments, 'This is a comment.');
      assert.strictEqual(wrapper.instance().nameFeedback, undefined);
      assert.strictEqual(wrapper.instance().commentsFeedback, undefined);
      assert.strictEqual(wrapper.instance().alertMessage, 'Something went wrong');
      assert.strictEqual(wrapper.instance().alertColor, 'danger');
      stub.restore();
    });
  });

  it('should render Alert with alert message and color', () => {
    const wrapper = mount(<FeedbackForm />);
    let alert = wrapper.find('Alert');
    assert.strictEqual(alert.length, 0);

    wrapper.instance().alertMessage = 'This is our alert message';
    wrapper.instance().alertColor = 'warriorsColors';
    wrapper.update();

    alert = wrapper.find('Alert');
    assert.strictEqual(alert.length, 1);
    assert.strictEqual(alert.prop('color'), 'warriorsColors');
    assert.strictEqual(alert.children().text(), '×This is our alert message');
  });

  it('adding a verification error for name should display an error via FormFeedback', () => {
    const wrapper = mount(<FeedbackForm />);

    wrapper.instance().nameFeedback = "can't be blank";
    wrapper.update();
    const fb = wrapper.find('FormFeedback').at(0);
    assert.strictEqual(fb.length, 1);
    assert.strictEqual(fb.children().text(), "can't be blank");
  });

  it('adding a verification error for comments should display an error via FormFeedback', () => {
    const wrapper = mount(<FeedbackForm />);

    wrapper.instance().commentsFeedback = "can't be blank";
    wrapper.update();
    const fb = wrapper.find('FormFeedback').at(1);
    assert.strictEqual(fb.length, 1);
    assert.strictEqual(fb.children().text(), "can't be blank");
  });

  it('changes to the feedback input should be reflected in the state and UI', () => {
    const wrapper = mount(<FeedbackForm />);

    let nameInput = wrapper.find('#feedbackName').first();
    assert.strictEqual(nameInput.prop('value'), '');
    nameInput.simulate('change', { target: { value: 'Luke' } });
    assert.strictEqual(wrapper.instance().name, 'Luke');
    nameInput = wrapper.find('#feedbackName').first();
    assert.strictEqual(nameInput.prop('value'), 'Luke');

    let commentInput = wrapper.find('#feedbackComments').first();
    commentInput.simulate('change', { target: { value: 'May the Force Push be with you' } });
    assert.strictEqual(wrapper.instance().comments, 'May the Force Push be with you');
    commentInput = wrapper.find('#feedbackComments').first();
    assert.strictEqual(commentInput.prop('value'), 'May the Force Push be with you');
  });

  it('handleDismiss should reset alertMessage and remove alert from UI', () => {
    const wrapper = mount(<FeedbackForm />);
    wrapper.instance().alertMessage = 'This is an alert';
    wrapper.instance().alertColor = 'danger';
    wrapper.update();

    let alert = wrapper.find('Alert');
    assert.strictEqual(alert.length, 1);

    wrapper.instance().handleDismiss();
    wrapper.update();

    assert.strictEqual(wrapper.instance().alertMessage, undefined);
    alert = wrapper.find('Alert');
    assert.strictEqual(alert.length, 0);
  });
});
