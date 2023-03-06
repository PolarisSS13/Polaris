import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Dropdown, Flex, Icon, Input, Modal, Section, Tabs } from '../components';
import { Window } from '../layouts';

export const ArcaneTome = (props, context) => {
  const { act, data } = useBackend(context);
  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 0);

  return (
    <Window
      width={300}
      height={400}
      resizable scrollable>
      <Window.Content>
        <Tabs>
          <Tabs.Tab
            selected={tabIndex === 0}
            onClick={() => { act("turnPage"); setTabIndex(0); }}>
            Archives
          </Tabs.Tab>
          <Tabs.Tab
            selected={tabIndex === 1}
            onClick={() => { act("turnPage"); setTabIndex(1); }}>
            Runes
          </Tabs.Tab>
        </Tabs>
        <Section>
          {
            tabIndex === 0
            && ("TBD")
            || tabIndex === 1
            && (
              <Flex
                direction="column"
                align="center">
                {data.runes.map(entry => (
                  <Flex.Item key={entry.name}>
                    <Button
                      textAlign="center"
                      content={entry.name}
                      tooltip={entry.shorthand}
                      onClick={() => act("writeRune", { runePath: entry.typepath })}
                    />
                  </Flex.Item>
                ))}
              </Flex>
            )
            || null
          }
        </Section>
      </Window.Content>
    </Window>
  );
};
