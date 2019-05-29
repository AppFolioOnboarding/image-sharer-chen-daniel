import React from 'react';
import { Container, Form, FormGroup, Label, Input, Button, FormFeedback, Alert } from 'reactstrap';
import { observer } from 'mobx-react';
import { observable, toJS, action } from 'mobx';
import * as api from '../utils/helper';

@observer
export default class FeedbackForm extends React.Component {
  @observable name = '';
  @action setName = (value) => {
    this.name = value;
    this.nameFeedback = undefined;
  }

  @observable comments = '';
  @action setComments = (value) => {
    this.comments = value;
    this.commentsFeedback = undefined;
  }

  @observable nameFeedback = undefined;
  @observable commentsFeedback = undefined;

  @observable alertMessage = undefined;
  @observable alertColor = undefined;

  @action
  handleDismiss = () => {
    this.alertMessage = undefined;
  }

  @action
  submitForm = (e) => {
    e.preventDefault();

    this.alertMessage = undefined;

    const data = {
      name: toJS(this.name),
      comments: toJS(this.comments)
    };

    return api.post('/api/feedbacks', data)
      .then((res) => {
        this.name = '';
        this.comments = '';
        this.alertMessage = res.message;
        this.alertColor = 'info';
      })
      .catch((err) => {
        if (err.data) {
          if (err.data.name) {
            this.nameFeedback = err.data.name;
          }
          if (err.data.comments) {
            this.commentsFeedback = err.data.comments;
          }
        } else {
          this.alertMessage = 'Something went wrong';
          this.alertColor = 'danger';
        }
      });
  };

  render() {
    return (
      <Container>
        {
          this.alertMessage && (
          <Alert
            toggle={() => this.handleDismiss()}
            color={this.alertColor}
          >
            {this.alertMessage}
          </Alert>
          )
        }
        <Form onSubmit={this.submitForm}>
          <FormGroup>
            <Label for="feedbackName">Your Name</Label>
            <Input
              type="text"
              name="name"
              id="feedbackName"
              onChange={e => this.setName(e.target.value)}
              value={this.name}
              invalid={!!this.nameFeedback}
            />
            <FormFeedback>{this.nameFeedback}</FormFeedback>
          </FormGroup>
          <FormGroup>
            <Label for="feedbackComments">Comments</Label>
            <Input
              type="textarea"
              name="comments"
              id="feedbackComments"
              onChange={e => this.setComments(e.target.value)}
              value={this.comments}
              invalid={!!this.commentsFeedback}
            />
            <FormFeedback>{this.commentsFeedback}</FormFeedback>
          </FormGroup>
          <Button color="primary">Submit</Button>
        </Form>
      </Container>
    );
  }
}
