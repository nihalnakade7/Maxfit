import { LightningElement,api } from 'lwc';

export default class EventTileComponent extends LightningElement {

    @api event;
    @api imageUrl;

    handleClick(event) {
        event.preventDefault();
        const selectEvent = new CustomEvent('select', {
            detail: {
                eventId: this.event.Id
            }
        });
        this.dispatchEvent(selectEvent);
    }
}