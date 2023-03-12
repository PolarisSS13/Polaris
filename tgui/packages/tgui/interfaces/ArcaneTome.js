import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Flex, Section, Tabs } from '../components';
import { Window } from '../layouts';

export const ArcaneTome = context => {
  const { act, data } = useBackend(context);
  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 0);
  const [compactMode, setCompactMode] = useLocalState(context, 'compactMode', 0);

  return (
    <Window
      width={500}
      height={600}
      theme="syndicate"
      resizable scrollable>
      <Window.Content scrollable>
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
                direction="column">
                <Button.Checkbox
                  inline
                  content="Compact mode"
                  checked={compactMode}
                  onClick={() => setCompactMode(!compactMode)} /><br />
                {!compactMode
                  && (
                    <Box>
                      {data.runes.map(entry => (
                        <Flex.Item key={entry.name} mb={1}>
                          <Section title={entry.name}>
                            {entry.invokers > 1
                              && (<Fragment><i>Required invokers:</i> {entry.invokers}<br /><br /></Fragment>) || ""}
                            {entry.talisman
                              && (<Fragment><i>Can be made into a talisman</i><br /><br /></Fragment>) || ""}
                            {entry.shorthand}<br /><br />
                            <Button
                              textAlign="center"
                              content="Scribe"
                              onClick={() => act("writeRune", { runePath: entry.typepath })}
                            />
                          </Section>
                        </Flex.Item>
                      ))}
                    </Box>)
                  || (
                    <Box align="center">
                      <i>Entries marked with an asterisk (*) can be made into a talisman.</i><br /><br />
                      {data.runes.map(entry => (
                        <Flex.Item key={entry.name} mb={1}>
                          <Button
                            content={(entry.talisman && entry.name + " *" || entry.name)
                              + (entry.invokers > 1 && " (" + entry.invokers + " invokers)" || "")}
                            tooltip={entry.shorthand}
                            onClick={() => act("writeRune", { runePath: entry.typepath })} />
                        </Flex.Item>
                      ))}
                    </Box>)}
              </Flex>
            )
            || null
          }
        </Section>
      </Window.Content>
    </Window>
  );
};
